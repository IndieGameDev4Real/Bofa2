class_name CameraFollow
extends Camera2D


export (bool) var will_snap := true
export (Vector2) var leash := Vector2(30, 30)
export (bool) var circular := false
export (float) var speed_scale := 0.1
export (Vector2) var min_speed := Vector2(2,2)

var parallax := Vector2(1.0,1.0)

onready var leash_len := leash.length()
export (NodePath) var target_path: NodePath
var target: Node2D

func _ready():
	target = get_node(target_path)
	if will_snap:
		snap_to_target()



func _physics_process(delta):
	
	if target != null:
		if circular:
			var diff = target.position - self.position
			var diff_len = diff.length()
			if diff_len > leash_len:
				var leashed = diff * (( diff_len - leash_len ) / diff_len )
				self.position += max_vec2( leashed/4, leashed.clamped(2) )
		else:
			
			# calculate the diff of self position and the position of target
			# mult by parallax for parallax scaling
			var dpos = parallax * ( target.position - self.position )
			
			# for x and y, check if the target is farther away than the "leash" on that axis
			# if so  
			var dist = Vector2.ZERO
			if abs( dpos.x ) > leash.x:
				dist.x = sign(dpos.x) * clamp(( abs(dpos.x) - leash.x ) * speed_scale, min_speed.x, 10000 )
			if abs( dpos.y ) > leash.y:
				dist.y = sign(dpos.y) * clamp(( abs(dpos.y) - leash.y ) * speed_scale, min_speed.y, 10000 )
			position += dist * delta * 60


func max_abs( a, b ):
	return a if abs(a) > abs(b) else b

func min_abs( a, b ):
	return a if abs(a) < abs(b) else b

func snap_to_target():
	if target != null:
		self.position = target.position * parallax

func set_target_node(node, snap = self.will_snap, parallax = Vector2(1.0,1.0) ):
	self.target = node
	if will_snap:
		snap_to_target()
	set_parallax( parallax )

func set_parallax( vec2: Vector2 ):
	self.parallax = vec2

func min_vec2( a: Vector2, b: Vector2 ) -> Vector2:
	return a if ( b.length_squared() - a.length_squared() ) > 0.0 else b
	
func max_vec2( a: Vector2, b: Vector2 ) -> Vector2:
	return a if ( a.length_squared() - b.length_squared() ) > 0.0 else b
