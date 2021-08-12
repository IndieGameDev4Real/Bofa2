class_name INGAME_UI
extends Control

signal paused()

func _on_pauseBtn_pressed():
	emit_signal("paused")
