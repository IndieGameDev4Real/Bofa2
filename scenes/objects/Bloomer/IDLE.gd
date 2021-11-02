extends Node
var fsm: StateMachine

func enter():
	pass

func exit():
	pass


func _on_DetectArea_body_entered(body):
	if body.owner is Player:
		owner.target = body.owner
		fsm.change_to("SHOOT")
	pass # Replace with function body.
