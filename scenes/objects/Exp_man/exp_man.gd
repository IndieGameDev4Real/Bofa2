extends Node2D


export var w: int = 10;
export var h: int = 10;
export var chain_len := Vector2(10, 10)
var chain_diag := chain_len.length()

var packed_point := preload("res://scenes/objects/Exp_man/MassPoint.tscn")



var mat = []
var springs = []

class Spring:
	var pnt_a: MassPoint
	var pnt_b: MassPoint
	var stiff: float
	var damp: float
	var rest: float
	
	func calc_force() -> float:
		return stiff * ((pnt_b.position - pnt_a.position).length() - rest)
	
	func calc_norm() -> Vector2:
		return pnt_a.position.direction_to(pnt_b.position)
	
	func _init(point_a: MassPoint, point_b: MassPoint, stiffness: float, rest_length: float ):
		self.pnt_a = point_a
		self.pnt_b = point_b 
		self.stiff = stiffness
		self.damp = damp
		self.rest = rest_length
		
	
	

func _ready():
	for i in range(h):
		mat.append([])
		
		for j in range(w):
			var point = packed_point.instance()
			point.position = Vector2( j * chain_len.x, i * chain_len.y )
			point.set_rad( min(chain_len.x, chain_len.y)/3 )
			add_child(point)
			mat[i].append( point )
			
			var stiff = 10
			
			if i > 0:
				springs.append( 
					Spring.new( point, mat[i-1][j], stiff, chain_len.x ))
				if j < w-1:
					springs.append(
						Spring.new( point, mat[i-1][j+1], stiff, chain_len.length() ))
			if j > 0:
				springs.append( 
					Spring.new( point, mat[i][j-1], stiff, chain_len.y ))
				if i > 0:
					springs.append(
						Spring.new( point, mat[i-1][j-1], stiff, chain_len.length() ))
	
	
	
	
func _physics_process(delta):
	
	for spring in springs: if spring is Spring:
		
		var force = spring.calc_force() * spring.calc_norm()
		
		
		spring.pnt_a.apply_central_impulse(  force )
		spring.pnt_b.apply_central_impulse( -force )
	
	update()

func _draw():
	for spring in springs: if spring is Spring:
		
		var force: float = spring.calc_force()
		var norm: Vector2 = spring.calc_norm()
		draw_line(spring.pnt_a.position, spring.pnt_b.position, Color.red, 1.0, false)
		
#		draw_line(spring.pnt_a.position, spring.pnt_a.position + (force * norm), Color.blue)
#		draw_line(spring.pnt_b.position, spring.pnt_b.position - (force * norm), Color.blue)
		
#		draw_line(spring.pnt_a.position, spring.pnt_a.position + (spring.pnt_a.linear_velocity), Color.blue)
#		draw_line(spring.pnt_b.position, spring.pnt_b.position + (spring.pnt_b.linear_velocity), Color.blue)
	
	for arr in mat:
		for pnt in arr:
			draw_rect(Rect2(pnt.position, Vector2(2, 2)), Color.rosybrown)
