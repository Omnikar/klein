@tool
extends Camera2D

@export var level_size: int = 12


func _ready() -> void:
	if !Engine.is_editor_hint():
		update_size()


func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		update_size()


func update_size() -> void:
	var width = ProjectSettings.get_setting("display/window/size/viewport_width")
	var height = ProjectSettings.get_setting("display/window/size/viewport_height")
	var size = Vector2(width, height)
	zoom = size / 8 / level_size
