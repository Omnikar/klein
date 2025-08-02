@tool
extends Control

@export var level_count: int = 1:
	get():
		return level_count
	set(value):
		level_count = value
		if $LevelSelect/GridContainer != null:
			for child in $LevelSelect/GridContainer.get_children():
				child.queue_free()
			for i in range(level_count):
				var button = preload("res://assets/scenes/objects/level_button.tscn").instantiate()
				button.level_num = i + 1
				$LevelSelect/GridContainer.add_child(button)


func _ready() -> void:
	level_count = level_count


func _on_start_button_pressed() -> void:
	print("start button pressed")


func _on_exit_button_pressed() -> void:
	print("exit button pressed")
