class_name PortalPhantomed extends Node

@export var phantoms: Array[Node2D]


func _ready() -> void:
	add_to_group("portal_phantomed")
