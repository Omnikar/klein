class_name Carryable extends RigidBody2D

@export var interact_area: Area2D


func _ready() -> void:
	freeze_mode = RigidBody2D.FREEZE_MODE_KINEMATIC
