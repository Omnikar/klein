extends Node


func find_ancestor(start: Node, condition: Callable) -> Variant:
	var current = start
	while not condition.call(current):
		current = current.get_parent()
		if current == null:
			return null
	return current


func load_level(level_num: int) -> void:
	get_tree().change_scene_to_file("res://assets/scenes/areas/level-%d.tscn" % level_num)
