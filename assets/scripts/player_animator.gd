@tool
extends Node2D

@export var player_controller: PlayerController
@export var animation_player: AnimationPlayer
@export var sprite: Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	sprite.flip_h = player_controller.get_node("PortalAffected").flipped

	if not Engine.is_editor_hint():
		if player_controller.relative_y_vel() > 0.01:
			animation_player.play("idle")
		elif player_controller.relative_y_vel() < -0.01:
			animation_player.play("idle")
		elif abs(player_controller.relative_x_vel()) > 0.001:
			animation_player.play("move")
		else:
			animation_player.play("idle")
