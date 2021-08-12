extends Node

var fsm: StateMachine
onready var player: Player = owner


func enter():
	pass

func _process(delta):
	pass

func exit():
	fsm.change_to("DASH")
