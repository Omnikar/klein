class_name Goal extends Node2D

signal goal_reached

@export_range(-90, 90, 1, "or_less", "or_greater", "radians_as_degrees")
var rotate_speed: float = PI / 6

@export var bob_freq: float = 1
@export var bob_ampl: float = 0.1

var anim_cycle = 0

var base_rot: float
var base_scale: Vector2


func _ready() -> void:
	base_rot = $Sprite2D.rotation
	base_scale = $Sprite2D.scale


func _process(delta: float) -> void:
	anim_cycle += delta

	$Sprite2D.rotation = base_rot - rotate_speed * anim_cycle

	var bob_diff = sin(anim_cycle * TAU * bob_freq) * bob_ampl
	$Sprite2D.scale = base_scale * (1 + bob_diff)


func _on_area_2d_body_entered(body: Node2D) -> void:
	print(body.name, " just reached the goal")
	goal_reached.emit()
