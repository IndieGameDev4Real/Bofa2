class_name Enemy
extends Actor

export var hp: int
export var max_hp: int = 100
onready var anim := $AnimationPlayer

func _ready():
	hp = max_hp

func knock(force: Vector2):
	pass

func damage(amt: int):
	pass

func death():
	pass
