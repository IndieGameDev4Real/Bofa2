extends Node

var fsm: StateMachine
onready var enemy: Enemy = owner

func enter():
	
	while true:
		if owner.target_node == owner:
			if len(owner.detect_queue) <= 0:
				fsm.change_to("IDLE")
				break
			else:
				owner.target_node = owner.pick_next_target()
		else:
			
			if owner.dist_from_target() < owner.atk_reach:
				fsm.change_to("ATTACK")
				break

			owner.move_path()
			
		yield(get_tree().create_timer(0.5), "timeout")

func exit():
	fsm.back()

func _on_DetectArea_body_exited(body):
	if owner.target_node == body:
		owner.target_node == owner
