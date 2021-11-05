extends Node
var fsm: StateMachine

func enter():
	owner.timer.start()
	pass

func exit():
	owner.timer.stop()
	fsm.back()
	pass


func _on_Timer_timeout():
	owner.anim.play("shoot")
	pass # Replace with function body.



func _on_AnimationPlayer_animation_changed(old_name, new_name):
	_on_AnimationPlayer_animation_finished(old_name)

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "shoot":
		owner.get_node("Timer").start()


func _on_DetectArea_body_exited(body):
	if owner == null:
		return
	if owner.target == null:
		return
	if body is Hitbox:
		body = body.owner
	if body == owner.target:
		owner.timer.stop()
		yield(owner.anim, "animation_finished")
		exit()
	pass # Replace with function body.

