class_name Actor
extends KinematicBody2D

var velocity
onready var center: Position2D = $Center
export var saved = true


func _ready():
	add_to_group("")

func get_center() -> Vector2:
	return center.position + position
