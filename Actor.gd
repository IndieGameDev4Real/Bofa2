class_name Actor
extends KinematicBody2D

export var velocity := Vector2.ZERO


func _physics_process(delta):
	position += velocity * delta
