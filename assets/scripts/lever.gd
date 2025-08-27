@tool
class_name Lever extends Interactable

signal lever_toggled(on: bool)

@export var color: Color = Color.WHITE:
	set(value):
		color = value
		if $KnobSprite:
			$KnobSprite.modulate = color

@export var flipped: bool = false

@export var on: bool = false:
	get():
		return on
	set(value):
		lever_toggled.emit(value)
		if not Engine.is_editor_hint():
			$ClickSound.click(value)
		on = value


func _process(_delta: float) -> void:
	var scale_modifier_x = -1 if flipped else 1
	var scale_modifier_y = -1 if on else 1
	scale.x = scale_modifier_x
	$BaseSprite.scale.y = scale_modifier_y
	$KnobSprite.scale.y = scale_modifier_y


func interact() -> void:
	on = !on
