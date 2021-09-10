extends Level

onready var player_data : PlayerData = get_node("/root/Global/player_data")
onready var tiles := $Sprite
onready var camera := $Camera
onready var sun := $Sun


func _ready():
	pass

func _process(delta):
	pass

func _on_INGAME_UI_paused():
	toggle_pause()
