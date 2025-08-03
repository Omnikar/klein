extends Node

var win_sound: AudioStreamPlayer


func _ready() -> void:
	win_sound = preload("res://assets/scenes/objects/win_sound.tscn").instantiate()
	add_child(win_sound)


func find_ancestor(start: Node, condition: Callable) -> Variant:
	var current = start
	while not condition.call(current):
		current = current.get_parent()
		if current == null:
			return null
	return current


func load_level(level_num: int) -> void:
	var result = get_tree().change_scene_to_file(
		"res://assets/scenes/areas/level_%d.tscn" % level_num
	)
	if result == ERR_CANT_OPEN:
		get_tree().change_scene_to_file("res://assets/scenes/areas/level_end.tscn")
		# return_to_menu()


func return_to_menu() -> void:
	get_tree().change_scene_to_file("res://assets/scenes/areas/menu.tscn")


func play_win_sound() -> void:
	win_sound.play()
