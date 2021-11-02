class_name Bloomer
extends Enemy

var spore_packed := preload("res://scenes/objects/Bloomer/Spore.tscn")
onready var timer = $Timer
onready var target: Node2D

func knock(force: Vector2):
	# does not move when knocked
	pass

func damage(amt: int):
	hp -= amt;
	anim.play("hurt")
	if hp < 0:
		death()
	pass

func death():
	queue_free()
	pass


func fire():
	var spore: Area2D = spore_packed.instance()
	if target != null:
		spore.target = target
	else:
		spore.target = self
	spore.position = position + $ShootPosition.position
	spore.shooter = self
	spore.impulse = position.direction_to(spore.target.position).rotated( 2.0 * (randf() - 0.5) ) * rand_range(7.5, 10.0)
	get_parent().call_deferred("add_child_below_node", owner, spore)


