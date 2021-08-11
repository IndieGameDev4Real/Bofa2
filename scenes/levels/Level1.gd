extends Level

onready var player_data : PlayerData = get_node("/root/Global/player_data")

func _ready():
	print(player_data.data["hp"])


func _on_INGAME_UI_paused():
	toggle_pause()
