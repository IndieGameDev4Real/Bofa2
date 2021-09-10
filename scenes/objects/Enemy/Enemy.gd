tool
class_name Enemy
extends Area2D

const DEBUG = true
const phi = 1.618
const type = "Enemy"

var ready = false

var detect_queue := [] 

# node path of init target (optional)
export var target_path: NodePath
export(Array, String) var target_types := ["Player"]

export var dash_base_len: float = 30;
export var dash_rand: float = 5;
export var atk_reach: float = 20;


# tool
export(float) var detect_dist setget set_detect_dist, get_detect_dist;

onready var target_node: Node2D = get_node(target_path) 
onready var tween: Tween = $Tween
onready var raycast: RayCast2D = $RayCast2D
onready var sm: StateMachine = $SM 
onready var anim_player: AnimationPlayer = $AnimationPlayer
onready var _log := $Log



func _ready(): 
	ready = true
	if target_path != null:
		target_node = get_node(target_path)
	else: 
		target_node = self

func move_path() -> void:
	tween.interpolate_property( 
		self, 
		"position", 
		self.position, 
		find_path(),
		0.3,
		Tween.TRANS_QUAD,
		Tween.EASE_OUT )
	tween.start()
	yield(tween, "tween_completed")
	tween.remove( self, "position" )



func find_path() -> Vector2:
	
	# the starting angle should be straight at the target node
	var rand_angle = self.position.angle_to_point( target_node.position )
	var max_tries = 20

	# this loops changes the direction of the raycast slightly, ...
	# and test the new direction for collosions, if the path is ...
	# blocked, it will rotate its path and try again until it ...
	# finds a clear path or a path straight toward the target ...
	# NOTE: the distance gets shorter each attempt, as to prevent from soft lock
	for i in range(max_tries):
		# pick new angle and force the raycast to update 
		rand_angle += (randf() * PI/4)
		raycast.cast_to = Vector2.LEFT.rotated(rand_angle) * dash_base_len * curv_util(1 - i / max_tries) * rand_range(0.5, 1.5)
		raycast.force_raycast_update()

		# check and handle collision
		var collider = raycast.get_collider()
		if collider != null:
			if DEBUG: print("\t", collider.name, " :: ", collider.get_class())
			
			# if the collider is the target_node, go straight to the node
			# otherwise, pick a new direction and check again
			if collider == target_node:
				var target_pos = raycast.get_collision_point()
				return position + target_pos.direction_to(position) * (target_pos.distance_to(position) - 10)
			else:
				continue;
		# if the loops runs fully, the current path is valid
		break
		
	# when this code is reached, the current path is valid and should be returned
	return position + raycast.cast_to


func get_all_collisions():
	var ray = raycast
	var objects_collide = [] #The colliding objects go here.
	while ray.is_colliding():
		var obj = ray.get_collider() #get the next object that is colliding.
		objects_collide.append( obj ) #add it to the array.
		ray.add_exception( obj ) #add to ray's exception. That way it could detect something being behind it.
		ray.force_raycast_update() #update the ray's collision query.

	#after all is done, remove the objects from ray's exception.
	for obj in objects_collide:
		ray.remove_exception( obj )
	
	return objects_collide



func step_away_dist(from: Vector2, dist: float) -> void:
	var new_pos = from + from.direction_to(position) * dist
	tween.interpolate_property( 
		self, 
		"position", 
		self.position, 
		new_pos,
		0.3,
		Tween.TRANS_QUAD,
		Tween.EASE_OUT )
	tween.start()
	yield(tween, "tween_completed")
	tween.remove( self, "position" )


func pick_next_target() -> PhysicsBody2D:
	var closest = self
	var dist = Vector2(1000, 0)
	for body in detect_queue:
		dist.y = body.distance_squared_to(self)
		if dist.y < dist.x:
			closest = body
			dist.x = dist.y
	return closest

func dist_from_target() -> float:
	return position.distance_to(target_node.position)


# SIGNALS AND CONNECTIONS

func _on_DetectArea_body_entered(body: Node2D):
	if target_types.has( body.get("type") ):
		detect_queue.append(body)
	
	sm.try_call_func("_on_DetectArea_body_entered", [body])

func _on_DetectArea_body_exited(body):

	# remove the exiting body from the list of in range bodies
	var i = detect_queue.find(body)
	if i >= 0: 
		detect_queue.remove(i)
	sm.try_call_func("_on_DetectArea_body_exited", [body])





# TOOL FUNCTIONS
# GETTERS AND SETTERS

func set_detect_dist(new_dist):
	if ready:
		$DetectArea/Collision.shape.radius = new_dist

func get_detect_dist():
	if ready:
		return $DetectArea/Collision.shape.radius



# valid for x in (0, 1] and p in (0, inf)
func curv_util(x, p = 3) -> float:	
	return 1 - ( 1 / (pow(x, p) - phi) + phi )

