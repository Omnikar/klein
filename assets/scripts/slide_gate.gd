@tool
class_name SlideGate extends Node2D

@export var open_speed: float = 10.0
@export var close_speed: float = 40.0
@export var open: bool = false

var open_pos: Vector2
var closed_pos: Vector2


func _ready():
	teleport_gate()


func _process(_delta: float):
	if Engine.is_editor_hint():
		teleport_gate()
		queue_redraw()


func teleport_gate():
	open_pos = $RailLayer.position
	closed_pos = $ClosedPos.position
	if open:
		$GateLayer.position = open_pos
	else:
		$GateLayer.position = closed_pos


func _physics_process(delta: float):
	if Engine.is_editor_hint():
		return

	var target_pos = open_pos if open else closed_pos
	var gate_speed = open_speed if open else close_speed
	var to_target: Vector2 = target_pos - $GateLayer.position
	var max_move_dist = gate_speed * delta

	if to_target.length() < max_move_dist:
		$GateLayer.position = target_pos
	else:
		$GateLayer.position += to_target.normalized() * max_move_dist


func set_open(new_open: bool):
	open = new_open
