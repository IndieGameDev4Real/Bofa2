extends Light2D

onready var tween := $Tween
onready var timer := $Timer

var POWER = Vector2(3, 10)

func _ready():
	timer.start()


func _on_timeout():
	tween.interpolate_property(self, "energy", 1.2, 0.0, 1, Tween.TRANS_LINEAR, Tween.EASE_IN )                         
	var pat = get_pattern()
	
	for delay in pat:
		tween.start()
		yield(get_tree().create_timer(delay), "timeout")
		tween.reset(self, "energy")
	
	yield(tween, "tween_all_completed")
	timer.wait_time = 3 + randf() * 3
	tween.remove_all()
	


func get_pattern():
	var pat = []
	for i in range(randi()%3+2):
		var length = 0.2 if randf() > 0.5 else 0.8
		pat.push_back( length * (0.5 + randf()))
	return pat


