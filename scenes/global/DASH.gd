extends Node

var fsm: StateMachine
onready var player: Player = owner

func enter():
	yield(get_tree().create_timer(0.2), "timeout")
	exit()

func exit():
	fsm.back()
