extends Node

var fsm: StateMachine
onready var enemy: Enemy

func _ready():
	enemy = owner

func enter():
	pass


func _on_DetectArea_body_entered(body):
	owner.anim_player.play("suprise_anim")
	yield(owner.anim_player, "animation_finished")

	owner.target_node = body
	
	fsm.change_to("TARGET")
