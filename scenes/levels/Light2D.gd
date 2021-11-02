extends Light2D

var strike := 0
var timer := 0.0
export var s_timer := 1.0

func _process(delta):
	timer += delta
	if timer > 0.1:
		light_strike()
		timer = 0
	if energy > 0.5:
		s_timer += delta
		energy -= delta / s_timer

func light_strike():
	strike = rand_range(0,500)
	if strike % 25 == 0:
		energy = rand_range(0.9, 1.3)

