class_name Player
extends Actor

export var ACCELERATION := 500
export var MAX_SPEED := 150
export var ROLL_SPEED := 300
export var FRICTION := 500

var roll_timer = -1
var attk_timer = -1
onready var tween = $Tween

enum { MOVE,
	ROLL,
	ATTACK,
	ITEM,
	NOPIE }

var state_stack = [MOVE]

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
			attack_state(delta)
		ITEM:
			pass
		NOPIE:
			pass
		

func get_dir():
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	).normalized()

func move_state(delta):
	var input_vector = get_dir()
	
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta * 9)
		pass
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		pass
	
	move()
	
	if Input.is_action_just_pressed("roll"):
		state = ROLL
	elif Input.is_action_just_pressed("attack"):
		state = ATTACK

func roll_state(delta):
	if roll_timer == -1:
		velocity = roll_vector * ROLL_SPEED
		roll_timer = 0.4
	elif roll_timer == 0:
		roll_timer = -1
		state = MOVE
	else:
		roll_timer = max(roll_timer - delta, 0)
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	move()
	
func attack_state(delta):
	if attk_timer == -1:
		$Sword.visible = true
		attk_timer = 0.1
		tween.interpolate_property($Sword, "rotation", $Sword.rotation - PI/2, $Sword.rotation + PI/2, attk_timer, Tween.TRANS_LINEAR)                   
		tween.start()
		state = MOVE
	elif attk_timer == 0:
		$Sword.visible = false
		attk_timer = -1
		tween.remove_all()
		$Sword.rotation = 0
	else:
		attk_timer = max(attk_timer - delta, 0)
	move()


func move():
	velocity = move_and_slide(velocity)
