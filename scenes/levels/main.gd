extends Node2D

var level1 = preload("res://scenes/levels/Level1.tscn")

func _on_Button_button_down():
	get_tree().change_scene_to(level1)
