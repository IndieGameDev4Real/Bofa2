extends Node

var fsm: StateMachine
onready var enemy: Enemy = owner

func enter():
	enemy.move_path()
	yield( enemy.tween, "tween_completed" )
	exit()

func exit():
	fsm.back()
