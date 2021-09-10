tool
class_name Enemy
extends KinematicBody2D

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
export var travel_time: float = 0.3;
export var rest_time: float = 0.3;

var dir := Vector2.ZERO
var speed := 0.0
var accel := 0.0

# tool
export(float) var detect_dist setget set_detect_dist, get_detect_dist;

onready var target_node: Node2D
onready var tween: Tween = $Tween
onready var sm = $SM 
onready var anim_player: AnimationPlayer = $AnimationPlayer
onready var _log := $Log
onready var debug_node := $debug



func _ready(): 
	ready = true
	if target_path != null:
		target_node = get_node(target_path)
	else: 
		target_node = self

func _physics_process(delta):
	move_and_slide( dir * speed, Vector2.ZERO, false, 4, 0.7, false )
	speed = max(0.0, speed + accel * delta)

func move_path() -> void:
	var X_max = (find_path())
	$debug/move_to.position = X_max
	
	
	var velo = 2 * X_max / travel_time

	accel = - 2 * X_max.length() / ( travel_time * travel_time )
	dir = velo.normalized()
	speed = velo.length()

func find_path() -> Vector2:
	
	# the starting angle should be straight at the target node
	var rand_angle = self.position.angle_to_point( target_node.position )
	var max_tries = 20
	var move_to = Vector2.ZERO

	# this loops changes the direction of the raycast slightly, ...
	# and test the new direction for collosions, if the path is ...
	# blocked, it will rotate its path and try again until it ...
	# finds a clear path or a path straight toward the target ...
	# NOTE: the distance gets shorter each attempt, as to prevent from soft lock
	for i in range(max_tries):
		# pick new angle and force the raycast to update 
		move_to = Vector2.LEFT.rotated(rand_angle) * dash_base_len
		rand_angle += (randf() * PI/4)
		
		var prev_pos = position
		var col := move_and_collide( move_to )
		var col_pos = position
		position = prev_pos

		if col != null:
			var collider = col.collider
			if DEBUG: print("\t", collider.name, " :: ", collider.get_class())
			
			# if the collider is the target_node, go straight to the node
			# otherwise, pick a new direction and check again
			if col.collider_id == target_node.get_instance_id():
				var target_pos = col_pos
				return col_pos - position
			else:
				continue;
		# if the loops runs fully, the current path is valid
		break
		
	# when this code is reached, the current path is valid and should be returned
	return move_to



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
		dist.y = body.position.distance_squared_to(position)
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
	if body == target_node:
		target_node = self
	# sm.try_call_func("_on_DetectArea_body_exited", [body])





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

