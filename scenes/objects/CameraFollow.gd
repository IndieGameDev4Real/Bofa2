class_name CameraFollow
extends Camera2D


export (bool) var will_snap := true
export (Vector2) var leash := Vector2(30, 30)
export (float) var speed_scale := 0.1
export (Vector2) var min_speed := Vector2(2,2)

var parallax := Vector2(1.0,1.0)
var off := Vector2.ZERO

onready var leash_len := leash.length()
export (NodePath) var target_path: NodePath
var target: Node2D

var exact_pos = self.position

func _ready():
	if target_path != null:
		target = get_node(target_path)
		if will_snap:
			snap_to_target()

func set_target(node: Node2D):
	target = node;
	if will_snap:
		snap_to_target()

func _physics_process(delta):
	
	if target != null:
		# calculate the diff of self position and the position of target
		# mult by parallax for parallax scaling
		var dpos = parallax * ( target.position - exact_pos )
		
		# for x and y, check if the target is farther away than the "leash" on that axis
		# if so  
		var dist = Vector2.ZERO
		if abs( dpos.x ) > leash.x:
			dist.x = sign(dpos.x) * clamp(( abs(dpos.x) - leash.x ) * speed_scale, min_speed.x, 10000 )
		if abs( dpos.y ) > leash.y:
			dist.y = sign(dpos.y) * clamp(( abs(dpos.y) - leash.y ) * speed_scale, min_speed.y, 10000 )
		exact_pos += dist * delta * 60
		
		if abs(dist.abs().angle() - PI/4) <= 0.1:
			exact_pos = exact_pos.round()
			
	position = exact_pos.round()


func snap_to_target():
	if target != null:
		self.exact_pos = target.position * parallax
		position = exact_pos.round()

func set_target_node(node, snap = self.will_snap, parallax = Vector2(1.0,1.0) ):
	self.target = node
	if will_snap:
		snap_to_target()
	set_parallax( parallax )



# UTIL

func set_parallax( vec2: Vector2 ):
	self.parallax = vec2

func min_vec2( a: Vector2, b: Vector2 ) -> Vector2:
	return a if ( b.length_squared() - a.length_squared() ) > 0.0 else b
	
func max_vec2( a: Vector2, b: Vector2 ) -> Vector2:
	return a if ( a.length_squared() - b.length_squared() ) > 0.0 else b


func max_abs( a, b ):
	return a if abs(a) > abs(b) else b

func min_abs( a, b ):
	return a if abs(a) < abs(b) else b
