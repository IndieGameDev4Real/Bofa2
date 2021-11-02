extends Node

var fsm: StateMachine
onready var player: Player = owner
var will_dash_atk = false

func enter():
	player.dash() 
	yield(get_tree().create_timer(0.2), "timeout")
	if will_dash_atk:
		player.dash_atk()
		pass
	exit()

func process(delta):
	if Input.is_action_just_pressed("attack"):
		will_dash_atk = true

func physics_process(delta):
	player.slow_down(delta)
	player.move(delta)

func exit():
	will_dash_atk = false
	fsm.back()
