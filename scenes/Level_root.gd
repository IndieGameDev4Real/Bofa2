extends Node2D

var loader: ResourceInteractiveLoader;

onready var UI = $HUD/INGAME_UI
onready var dmg_border = $HUD/dmg_border
onready var level = $Level;



func _ready():
	switch_level("res://scenes/levels/Level1.tscn", 0)

func switch_level(level_name: String, door_id):
	var new_level = load(level_name)
	if new_level != null:
		switch_level_to(new_level, door_id)
	else:
		print("loaded level did not work! oh shiiiiiit!!!!!!!!! path: " + level_name)

func switch_level_to(packed_level: PackedScene, door_id):
	
	if level != null:
		level.connect("tree_exited", self, "start_level", [packed_level], CONNECT_ONESHOT)
		level.exit()
		remove_child(level)
	start_level(packed_level, door_id)



func start_level(packed_level, door_id):
	var new_level = packed_level.instance()
	new_level.start_point_id = door_id
	call_deferred("add_child", new_level)
	level = new_level


func start_dialog( npc: String, name: String ):
	UI.start_dialog( npc, name )

func _on_INGAME_UI_paused():
	if level != null:
		level.toggle_pause()
