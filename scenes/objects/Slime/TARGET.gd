extends Node

var fsm: StateMachine
onready var enemy
onready var timer: Timer


func _ready():
	enemy = owner
	timer = $Timer



func enter():
	timer.start( enemy.travel_time + enemy.rest_time )


func exit():
	timer.stop()
	fsm.back()

func _on_DetectArea_body_exited(body):
	if enemy.target_node == body:
		enemy.target_node == enemy


func _on_Timer_timeout():
	if enemy.target_node == enemy:
		if len(enemy.detect_queue) == 0:
			exit()
			return;
		else:
			enemy.target_node = enemy.pick_next_target()
	else:
		enemy.move_path()
		
