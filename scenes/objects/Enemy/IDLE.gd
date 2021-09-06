extends Node

var fsm: StateMachine
onready var enemy: Enemy = owner

func enter():
	yield(get_tree().create_timer(0.5), "timeout")
	fsm.change_to("DASH")

