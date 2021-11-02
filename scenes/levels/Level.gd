class_name Level
extends Node2D



onready var player_data : PlayerData = get_node("/root/Global/player_data")
onready var camera : CameraFollow = $Camera
onready var anims : AnimationPlayer = get_node("/root/Level_root/GlobalAnims")
onready var start_points := get_tree().get_nodes_in_group("level_switch")
var player_scene : PackedScene = preload("res://scenes/objects/Player/Player.tscn");
var player : Player
var start_point_id

var state = PLAY

func _ready():
	
	player = player_scene.instance()
	
	var pos = Vector2.ZERO
	if len(start_points) > 0:
		var start_point
		for i in start_points:
			start_point = i
			if start_point.door_id == start_point_id:
				break
		
		pos = start_point.position + start_point.start_point
		start_point.get_parent().add_child_below_node(start_point, player)
	else:
		add_child(player)
	
	
	player.position = pos
	player.connect("damaged", self, "_on_Player_damaged")
	
	camera.set_target(player)
	pass
	



func toggle_pause():
	match state:
		PAUSE: set_pause(false)
		PLAY: set_pause(true)

func _on_Player_damaged(amt):
	if amt >= 1: 
		anims.play("dmg_average")
	pass # Replace with function body.


func set_pause( paused ):
	get_tree().paused = paused
	state = PAUSE if paused else PLAY

func set_player( player: Player ):
	self.player = player

func exit():
	queue_free()
	pass

enum {
	NULL,
	PLAY,
	PAUSE,
}
