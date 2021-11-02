class_name State
extends Node
var fsm: Object

func enter():
	pass

func exit(next_state = null):
	pass

func process(delta):
	return delta

func physics_process(delta):
	return delta

func input(event):
	return event

func unhandled_input(event):
	return event

func unhandled_key_input(event):
	return event

func notification(what, flag = false):
	return [what, flag]
