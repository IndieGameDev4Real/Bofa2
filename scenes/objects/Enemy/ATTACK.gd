extends Node


var fsm: StateMachine
onready var enemy: Enemy = owner

func enter():
	owner.step_away_dist(owner.target_node.position, owner.atk_reach)
	


func exit():
	fsm.back()

