@tool
class_name LevelButton extends Control

# signal level_button_pressed(level_num: int)

@export var level_num: int = 0


func _ready() -> void:
	update_display_num()


func _process(_delta: float) -> void:
	update_display_num()


func update_display_num() -> void:
	$Button.text = str(level_num)


func _on_button_pressed() -> void:
	Utils.load_level(level_num)
