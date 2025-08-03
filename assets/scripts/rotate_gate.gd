@tool
class_name RotateGate extends Node2D

@export_range(-180, 180, 1, "or_less", "or_greater", "radians_as_degrees")
var open_rotation: float = PI / 2

@export_range(-720, 720, 1, "or_less", "or_greater", "radians_as_degrees") var open_speed: float = PI

@export_range(-720, 720, 1, "or_less", "or_greater", "radians_as_degrees")
var close_speed: float = PI

@export var open: bool = false

var target_rot: float:
	get():
		return open_rotation if open else 0.0

var gate_speed: float:
	get():
		return open_speed if open else close_speed


func _ready() -> void:
	teleport_gate()


func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		teleport_gate()
		queue_redraw()


func teleport_gate() -> void:
	$Pivot.rotation = target_rot


func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return

	var to_target: float = target_rot - $Pivot.rotation
	var max_rot = gate_speed * delta

	if abs(to_target) < max_rot:
		$Pivot.rotation = target_rot
	else:
		$Pivot.rotation += sign(to_target) * max_rot


func set_open(new_open: bool) -> void:
	open = new_open
