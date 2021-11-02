class_name LevelSwitch
extends Area2D

export(String, FILE, "*.tscn") var level_path;
export(int) var door_id
export(int) var goto

onready var start_point = $enter_point.position

func _enter_tree():
	set_collision_layer_bit(0, false )
	set_collision_layer_bit(1, true )
	add_to_group("level_switch")
	self.connect("body_entered", self, "_on_body_entered")


func _on_body_entered(body):
	if body is Player && level_path != null:
		get_node("/root/Level_root/").switch_level(level_path, goto)
