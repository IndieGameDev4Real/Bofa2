class_name Player
extends Actor

export var ACCELERATION := 500
export var MAX_SPEED := 150
export var ROLL_SPEED := 300
export var FRICTION := 500

enum { MOVE,
	ROLL,
	ATTACK,
	ITEM,
	NOPIE }

var state = MOVE
var roll_vector = Vector2.ZERO

func _ready():
	pass

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			roll_state(delta)
		ATTACK:
			pass
		ITEM:
			pass
		NOPIE:
			pass
		

func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	input_vector = input_vector.normalized()
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * 9)
		pass
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		pass
	
	move()
	
	if Input.is_action_just_pressed("roll"):
		state = ROLL

func roll_state(delta):
	velocity = roll_vector * ROLL_SPEED
	move()
	state = MOVE

func attack_state(delta):
	pass

func move():
	velocity = move_and_slide(velocity)
