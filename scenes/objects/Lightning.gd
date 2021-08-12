extends Light2D

var tween

func _ready():
	var tween = Tween.new()
	add_child(tween)
