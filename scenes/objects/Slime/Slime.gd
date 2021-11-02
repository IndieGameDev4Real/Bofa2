tool
class_name Slime
extends Enemy

const DEBUG = false
const phi = 1.618
const type = "Enemy"


var ready = false

var detect_queue := [] 

# node path of init target (optional)
export var target_path: NodePath
export(Array, String) var target_types := ["Player"]

export var dash_base_len: float = 40;
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

func target_pos() -> Vector2:
	if target_node == null:
		return position
	if target_node.has_method("get_center"):
		return target_node.get_center()
	else:
		return target_node.center

func _physics_process(delta):
	var vel = move_and_slide( dir * speed, Vector2.ZERO, false, 4, 0.7, false )
	if get_slide_count() > 0:
		var slide = get_slide_collision(0)
		var norm = slide.normal
		dir = norm.rotated( norm.angle() - (-dir).angle() )
		
		var collider = slide.collider
		if collider is Hitbox:
			collider = collider.owner
		
		if collider is Player:
			collider.damage(1)
			position += collider.position.direction_to(position) * 5.0
			collider.knock_back(-dir * 100)
			
	speed = max(0.0, speed + accel * delta)

func move_path(move_to = null) -> void:
	if move_to == null:
		move_to = find_path()
	var X_max = move_to
	$debug/move_to.position = X_max
	
	var velo = 2 * X_max / travel_time

	accel = - 2 * X_max.length() / ( travel_time * travel_time )
	dir = velo.normalized()
	speed = velo.length()

func find_path() -> Vector2:
	
	# the starting angle should be straight at the target node
	var rand_angle = self.position.angle_to_point( target_pos() )
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
			
			# if the collider is the target_node, go straight to the node + half the dash length
			# otherwise, pick a new direction and check again
			if col.collider == target_node || col.collider.owner == target_node:
				var target_pos = (col_pos - position);
				target_pos = target_pos.normalized() * (target_pos.length() + dash_base_len/2.0);
				return target_pos
			else:
				continue;
		# if the loops runs fully, the current path is valid
		break
		
	# when this code is reached, the current path is valid and should be returned
	return move_to

func damage(amt):
	hp -= amt
	if hp <= 0:
		death()
	else:
		anim.play("dmg")

func knock(force: Vector2): 
	move_path(force)
	$Splat.emitting = true
	$Splat.rotation = (-force).angle()

func death():
	queue_free()
	

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
	return position.distance_to(target_pos())


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


