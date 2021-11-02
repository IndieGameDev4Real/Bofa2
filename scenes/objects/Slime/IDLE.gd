extends Node

var fsm: StateMachine

func enter():
	pass

func _on_DetectArea_body_entered(body):
	owner.anim_player.play("suprise_anim")
	owner.target_node = body
	fsm.change_to("TARGET")
