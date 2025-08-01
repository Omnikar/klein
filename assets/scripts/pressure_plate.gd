@tool
class_name PressurePlate extends Node2D

signal plate_pressed
signal plate_lifted
signal plate_updated(pressed: bool)

@export var color: Color = Color.WHITE:
	set(value):
		color = value
		if $PlateSprite:
			$PlateSprite.modulate = color

var pressers: int = 0:
	get():
		return pressers
	set(value):
		var old = pressers
		pressers = value
		if old != value:
			send_plate_signals()
var pressed: bool:
	get():
		return pressers > 0


func _ready() -> void:
	pass


func _process(_delta: float) -> void:
	if not Engine.is_editor_hint():
		$PlateSprite.visible = !pressed


func _on_plate_body_entered(body: Node2D) -> void:
	if body == $Base:
		return
	pressers += 1


func _on_plate_body_exited(body: Node2D) -> void:
	if body == $Base:
		return
	pressers = max(0, pressers - 1)


func send_plate_signals() -> void:
	plate_updated.emit(pressed)
	if pressed:
		plate_pressed.emit()
	else:
		plate_lifted.emit()
