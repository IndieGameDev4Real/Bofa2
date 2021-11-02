class_name Player
extends Actor

signal damaged(amt)

const format = "std"
const type = "Player"

onready var tween := $Tween
onready var sm := $SM
onready var sprite := $Sprite
onready var sword := $Sword
onready var anim := $AnimationPlayer
onready var global = get_node("/root/Global/player_data")

export var ACCELERATION := 1200.0
export var MAX_SPEED := 200.0
export var dash_SPEED := 400.0
export var FRICTION := 900.0

var facing := Vector2.DOWN
var dir := Vector2.DOWN

func _ready():
	velocity = Vector2.ZERO

func walk(delta):
	velocity = velocity.move_toward(dir * MAX_SPEED, ACCELERATION * delta)

func slow_down(delta):
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

func move(delta):
	velocity = move_and_slide(velocity) 

func dash():
	velocity = facing.normalized() * dash_SPEED


func atk():
	sword.rotation = facing.angle() + PI/2
	anim.play("attack")

func dash_atk():
	sword.rotation = facing.angle() + PI/2
	anim.play("dash_attack")

func damage(dmg: int) -> void:
	emit_signal("damaged", dmg)
	global.data["hp"] = global.data["hp"] - dmg
	

func knock_back(force: Vector2) -> void:
	velocity = force

#########################################
#########################################
#########################################





func get_dir() -> Vector2:
	self.dir = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	).normalized()
	return dir

func try_set_anim(name):
	if sprite.animation != name:
		sprite.animation = name;


func set_anim(dir: Vector2, still = false ):
	if dir.angle() <= 0.01 + PI * 3/4 and dir.angle() >= PI / 4:
		try_set_anim("walking_down")
	elif dir.angle() >= -0.01 - PI * 3/4 and dir.angle() <= -PI / 4:
		try_set_anim("walking_up")
	else:
		try_set_anim("idle")


func _on_Sword_body_entered(body):
	if body is Hitbox:
		body = body.owner
	if body is Enemy:
		body.knock(position.direction_to(body.position).normalized() * 50)
		body.damage(1)
	

