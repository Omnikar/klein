extends Node


func find_ancestor(start: Node, condition: Callable) -> Variant:
	var current = start
	while not condition.call(current):
		current = current.get_parent()
		if current == null:
			return null
	return current
