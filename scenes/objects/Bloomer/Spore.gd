extends Area2D

var shooter
export var damage := 10

var target: Node2D
var force: Vector2
var impulse: Vector2
var vel: Vector2

func _ready():
	$AnimationPlayer.play("disapear")

func integrate(delta: float) -> Vector2:
	vel += force * delta
	vel += impulse
	impulse = Vector2.ZERO
	return vel

func _on_Spore_body_entered(body):
	if body is Hitbox:
		body = body.owner
	if body is Player:
		body.damage(10)
	elif body.owner is Player:
		body.owner.damage(10)
	if body != shooter:
		queue_free()

func _physics_process(delta):
	integrate(delta)
	position += vel
	
	var target_pos
	if target is Actor:
		target_pos = target.get_center()
	else:
		target_pos = target.position
	
	if target != null:
		force = position.direction_to(target_pos) / position.distance_to(target_pos)
		force *= 400.0
		force = force.clamped(10.0)
		impulse += -vel * 0.1
#		position = position.move_toward(target_pos, 10.0 * delta)
		
