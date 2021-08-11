class_name Level
extends Node2D

enum {
	NULL,
	PLAY,
	PAUSE,
}

var state = PLAY

func toggle_pause():
	match state:
		PAUSE: set_pause(false)
		PLAY: set_pause(true)
	


func set_pause( paused ):
	get_tree().paused = paused
	state = PAUSE if paused else PLAY



func switch_level(level_id):
	pass
