tool
class_name Enemy
extends Area2D

var DEBUG = true

var type = "Enemy"
export var target_path: NodePath

export var dash_base_len: float = 30;
export var dash_rand: float = 5;
onready var atk_reach: float = 20;

export var detect_dist: float setget set_detect_dist, get_detect_dist;

onready var target_node: Node2D = get_node(target_path) 
onready var tween: Tween = $Tween
onready var raycast: RayCast2D = $RayCast2D


var phi = 1.618


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
	print("moving to: ", position)
	yield(tween, "tween_completed")
	tween.remove( self, "position" )



func find_path() -> Vector2:
	
	# the starting angle should be straight at the target node
	var angle = self.position.angle_to_point( target_node.position )
	var rand_angle = angle
	var max_tries = 20

	# this loops changes the direction of the raycast slightly, ...
	# and test the new direction for collosions, if the path is ...
	# blocked, it will rotate its path and try again until it ...
	# finds a clear path or a path straight toward the target
	for i in range(max_tries):
		
		# pick new angle and force the raycast to update 
		rand_angle += (randf() * PI/4)
		raycast.cast_to = Vector2.LEFT.rotated(rand_angle) * dash_base_len * (randf() * 0.5 + 0.5) * (1 - i / max_tries)
		raycast.force_raycast_update()


		# check and handle collision
		var collider = raycast.get_collider()
		if collider != null:
			
			# debug info
			if DEBUG: print("\t", collider.name, " :: ", collider.get_class())
			
			# if the collider is the target_node, go straight to the node
			# otherwise, pick a new direction and check again
			if collider == target_node:
				return raycast.get_collision_point()
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

# SIGNALS AND CONNECTIONS

func _on_body_detected(body):
	if body is Player:
		target_node = body



# TOOL FUNCTIONS
# GETTERS AND SETTERS

func set_detect_dist(new_dist):
	$DetectRange/Collision.shape.radius = new_dist

func get_detect_dist():
	return $DetectRange/Collision.shape.radius



# valid for x in (0, 1] and p in (0, inf)
func curv_util(x, p) -> float:	
	return ( 1 / (pow(x, p) - phi) + phi )
