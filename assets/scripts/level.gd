extends Node2D

@export var level_num: int = 0


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		Utils.return_to_menu()


func load_next_level() -> void:
	if level_num != 0:
		Utils.load_level(level_num + 1)
