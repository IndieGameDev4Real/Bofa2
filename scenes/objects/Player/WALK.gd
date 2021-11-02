extends Node

var fsm: StateMachine
onready var player = owner


func enter():
	pass

func physics_process(delta):
	if Input.is_action_just_pressed("dash"):
		exit()
	
	var dir = player.get_dir()
	
	if dir != Vector2.ZERO:
		if not player.sprite.playing:
			player.sprite.play()
		player.facing = dir
		player.set_anim(player.facing)
		player.walk(delta)
	elif dir == Vector2.ZERO:
		player.sprite.stop()
		player.sprite.frame = 0
		player.slow_down(delta) 
	player.move(delta)

func process(delta):
	if Input.is_action_just_pressed("attack"):
		player.atk()
	pass



# func unhandled_input(event):
# 	if event is InputEventMouseButton:
# 		if event.pressed:
			# player.atk()

func exit():
	fsm.change_to("DASH")


