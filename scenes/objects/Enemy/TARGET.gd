extends Node

var fsm: StateMachine
onready var enemy: Enemy = owner

func enter():
	exit()

func exit():
	fsm.back()
