class_name LogicGate extends Node

signal updated(state: bool)

enum GateType { And, Or, Xor, Nand, Nor, Xnor }

@export var gate_type: GateType = GateType.And

var state0: bool = false
var state1: bool = false

var last_output: bool


func _ready() -> void:
	last_output = compute()
	updated.emit(last_output)


func input0(state: bool) -> void:
	state0 = state
	update()


func input1(state: bool) -> void:
	state1 = state
	update()


func compute() -> bool:
	match gate_type:
		GateType.And:
			return state0 and state1
		GateType.Or:
			return state0 or state1
		GateType.Xor:
			return state0 != state1
		GateType.Nand:
			return not (state0 and state1)
		GateType.Nor:
			return not (state0 or state1)
		GateType.Xnor:
			return state0 == state1
		_:
			return false


func update() -> void:
	var output = compute()
	if output != last_output:
		last_output = output
		updated.emit(output)
