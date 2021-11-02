extends Node2D


var points = []
var springs = []
export var point_count := 25
export var chain_len := 7.0
export var init_pressure := 1000.0
var ideal_area = 0.0
const STIFFNESS = 1.0

var packed_point := preload("res://scenes/objects/Exp_man/MassPoint.tscn")


class Spring:
	var pnt_a: MassPoint
	var pnt_b: MassPoint
	var rest: float
	var stiff: float
		
	func calc_force() -> float:
		var force = stiff * ((pnt_b.position - pnt_a.position).length() - rest)
		
		if force > 0: force *= 40
		
		return force 
	
	func calc_norm() -> Vector2:
		return pnt_a.position.direction_to(pnt_b.position)
	
	func _init(point_a: MassPoint, point_b: MassPoint, rest_length: float, stiffness: float = -1 ):
		self.pnt_a = point_a
		self.pnt_b = point_b 
		self.rest = rest_length
		self.stiff = STIFFNESS if stiffness == -1 else stiffness




func _ready():
	var R = chain_len / ( 2 * sin(PI/ point_count) )

	var apothem = sqrt( R*R + chain_len*chain_len * 0.25 )
	ideal_area = point_count * chain_len * apothem * 0.5
	for i in range(point_count):
		var point = packed_point.instance()
		
		point.position = Vector2(
			cos( i * TAU / point_count ) * R,
			sin( i * TAU / point_count ) * R  )
		point.set_rad(chain_len/3)
		points.append(point)
		add_child(point)

		if i > 0:
			springs.append( Spring.new( point, points[i - 1], chain_len ) )
	springs.append( Spring.new( points[0], points[point_count-1], chain_len ))

	
func _physics_process(delta):

	var P = calc_pressure()

	for spring in springs: if spring is Spring:
		var norm = spring.calc_norm()
		var spring_force = spring.calc_force() * norm
		var perp = norm.rotated(PI/2)
		var pressure_force = perp * P
#		pressure_force = Vector2.ZERO
		
		var rand = Vector2( randf(), randf() ) * 0.001

		spring.pnt_a.apply_central_impulse( pressure_force + spring_force + rand )
		spring.pnt_b.apply_central_impulse( pressure_force - spring_force + rand )

	init_pressure += init_pressure * delta
	init_pressure += delta
	update()

func _draw():
	for spring in springs: if spring is Spring:
		draw_line(spring.pnt_a.position, spring.pnt_b.position, Color.red, 1.0, false)
		

func calc_area() -> float:
	var area = 0.0;
	for n in range(point_count):
		var j = (n+1) % point_count
		area += points[n].position.x * points[j].position.y
		area -= points[n].position.y * points[j].position.x
	return abs(area * 0.5)

func calc_pressure() -> float:
	var area = calc_area()
	if area == 0:
		pass
	return init_pressure * ideal_area / calc_area()
