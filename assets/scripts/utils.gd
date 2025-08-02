extends Node


func find_ancestor(start: Node, condition: Callable) -> Variant:
	var current = start
	while not condition.call(current):
		current = current.get_parent()
		if current == null:
			return null
	return current


func load_level(level_num: int) -> void:
	var result = get_tree().change_scene_to_file(
		"res://assets/scenes/areas/level-%d.tscn" % level_num
	)
	if result == ERR_CANT_OPEN:
		return_to_menu()


func return_to_menu() -> void:
	get_tree().change_scene_to_file("res://assets/scenes/areas/menu.tscn")
