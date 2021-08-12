class_name Player
extends Actor

onready var tween = $Tween
onready var sm = $SM
onready var sprite = $Sprite

export var ACCELERATION := 1000
export var MAX_SPEED := 150
export var dash_SPEED := 400
export var FRICTION := 1000


var facing := Vector2.DOWN
var dir := Vector2.DOWN


func _physics_process(delta):
	dir = get_dir()
	if dir != Vector2.ZERO: facing = dir
	match sm.state.name:
		"WALK":
			move_state(delta)
		"DASH":
			dash_state(delta)


func move_state(delta):
	if Input.is_action_just_pressed("dash"):
		sm.change_to("DASH")
		velocity = velocity.normalized() * dash_SPEED
	set_anim(dir)
	
	if dir != Vector2.ZERO:
		velocity = velocity.move_toward(dir * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	move()
	

func dash_state(delta):
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	move()


func move():
	velocity = move_and_slide(velocity)





#########################################
#########################################
#########################################





func get_dir():
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	).normalized()


func set_anim(dir):
	if dir == Vector2.ZERO:
		if sprite.animation != "idle":
			sprite.animation = "idle"
	else:
		if sprite.animation != "walking_down":
			sprite.animation = "walking_down"
