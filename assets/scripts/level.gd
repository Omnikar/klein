extends Node2D

@export var level_num: int = 0


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		return_to_menu()


func load_next_level() -> void:
	Utils.load_level(level_num + 1)


func return_to_menu() -> void:
	get_tree().change_scene_to_file("res://assets/scenes/areas/menu.tscn")
