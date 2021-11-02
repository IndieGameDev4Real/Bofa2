class_name PlayerData
extends Node

func get_hp_ratio():
	return float(data.get("hp")) / float(data.get("max_hp"))




var data = {
	"hp": 90,
	"max_hp": 100,
	"lvl": 1,
	"name": "MamaMan"
}
