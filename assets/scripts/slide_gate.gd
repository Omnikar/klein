@tool
class_name SlideGate extends Node2D

@export var open_speed: float = 40.0
@export var close_speed: float = 40.0
@export var open: bool = false

var open_pos: Vector2
var closed_pos: Vector2

var target_pos: Vector2:
	get():
		return open_pos if open else closed_pos

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
	open_pos = $RailLayer.position
	closed_pos = $ClosedPos.position
	$GateLayer.position = target_pos


func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return

	var to_target: Vector2 = target_pos - $GateLayer.position
	var max_move_dist = gate_speed * delta

	if to_target.length() < max_move_dist:
		$GateLayer.position = target_pos
	else:
		$GateLayer.position += to_target.normalized() * max_move_dist


func set_open(new_open: bool) -> void:
	open = new_open
