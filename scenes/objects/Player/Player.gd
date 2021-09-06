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
#	elif Input.is_action_just_pressed("attack"):
#		atk():
	
	set_anim(dir)
	
	if dir != Vector2.ZERO:
		velocity = velocity.move_toward(dir * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	move()
	

func dash_state(delta):
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	move()

#func atk():
#	play.animation
#	hitbox = true
#	when animation.end:
#		hitbox = false
#		state something#

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

func try_set_anim(name):
	if sprite.animation != name:
		sprite.animation = name;


func set_anim(dir):
	if dir.angle() <= 0.01 + PI * 3/4 and dir.angle() >= PI / 4:
		try_set_anim("walking_down")
	elif dir.angle() >= -0.01 - PI * 3/4 and dir.angle() <= -PI / 4:
		try_set_anim("walking_up")
	else:
		try_set_anim("idle")
