@tool
extends Control

@export var bob_freq: float = 0.2
@export var bob_ampl: float = 0.05
var anim_cycle: float = 0
var title_base_scale: Vector2

@export var level_count: int = 1:
	get():
		return level_count
	set(value):
		level_count = value
		if has_node("LevelSelect/GridContainer"):
			for child in $LevelSelect/GridContainer.get_children():
				child.queue_free()
			for i in range(level_count):
				var button = preload("res://assets/scenes/objects/level_button.tscn").instantiate()
				button.level_num = i + 1
				$LevelSelect/GridContainer.add_child(button)


func _ready() -> void:
	level_count = level_count
	if not Engine.is_editor_hint():
		title_base_scale = $Title.scale


func _on_start_button_pressed() -> void:
	print("start button pressed")


func _on_exit_button_pressed() -> void:
	print("exit button pressed")


func _process(delta: float) -> void:
	if not Engine.is_editor_hint():
		anim_cycle += delta
		var bob_diff = sin(anim_cycle * TAU * bob_freq) * bob_ampl
		$Title.scale = title_base_scale * (1 + bob_diff)
