class_name Player
extends Actor

var accel := Vector2.ZERO

func _ready():
	pass

func get_direction():
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	).normalized()


func _physics_process(delta):
	velocity = get_direction() * 100
	
