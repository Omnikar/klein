class_name Portal
extends Marker2D

@export var other_portal: Portal
@export var flipped: bool = false

var start: Vector2
var end: Vector2
var length: float
var angle: float

var phantoms: Array[Node2D] = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_params()


func update_params():
	var start_ = global_position
	var end_ = $Endpoint.global_position
	if flipped:
		start = end_
		end = start_
	else:
		start = start_
		end = end_
	length = (end - start).length()
	angle = (end - start).angle()


func _process(_delta: float):
	clear_phantoms()
	var objects = get_tree().get_nodes_in_group("portal_affected") as Array[PortalAffected]
	for obj in objects:
		make_phantom(obj)
	objects = get_tree().get_nodes_in_group("portal_displayed") as Array[PortalAffected]
	for obj in objects:
		make_phantom(obj)


func _physics_process(_delta: float):
	update_params()

	var objects = get_tree().get_nodes_in_group("portal_affected") as Array[PortalAffected]
	for obj in objects:
		var intersect = obj.portal_intersect(start, end)
		if intersect is Vector2:
			print("I am ", name, ". My other portal is ", other_portal.name)
			print(obj.transform_node.name, " just passed through ", name)
			teleport(obj, intersect)


func should_flip() -> bool:
	return flipped != other_portal.flipped


func flip(v: Vector2) -> Vector2:
	if should_flip():
		return v.reflect((other_portal.end - other_portal.start).normalized())
	else:
		return v


# TODO: Change scale if the portals are different sizes?
func teleport(obj: PortalAffected, entrance: Vector2):
	var rotate_angle = other_portal.angle - angle
	print("rotate angle: ", rotate_angle)

	var t = (entrance - start).length() / length
	var exit = (1 - t) * other_portal.start + t * other_portal.end
	var exit_delta = (obj.this_pos - entrance).rotated(rotate_angle)
	var final_pos = flip(exit_delta) + exit
	print("t: ", t)
	print("exit: ", exit)
	print("final pos: ", final_pos)

	obj.transform_node.global_translate(final_pos - obj.this_pos)
	obj.reset_pos_history()
	obj.transform_node.rotation += rotate_angle
	if should_flip():
		var refl_axis_angle = obj.transform_node.rotation + obj.reflect_axis_angle
		var extra_rotation = 2 * (other_portal.angle - refl_axis_angle)
		obj.transform_node.rotation += extra_rotation

	if obj.transform_node is CharacterBody2D:
		print("old velocity: ", obj.transform_node.velocity)
		var new_vel = obj.transform_node.velocity.rotated(rotate_angle)
		obj.transform_node.velocity = flip(new_vel)
		print("new velocity: ", obj.transform_node.velocity)
	elif obj.transform_node is RigidBody2D:
		print("old velocity: ", obj.transform_node.linear_velocity)
		obj.transform_node.set_linear_velocity(
			obj.transform_node.linear_velocity.rotated(rotate_angle)
		)
		print("new velocity: ", obj.transform_node.linear_velocity)

	if should_flip():
		obj.flipped = !obj.flipped


func clear_phantoms():
	for phantom in phantoms:
		phantom.queue_free()
	phantoms = []


func make_phantom(obj: PortalDisplayed):
	for graphic in obj.graphics:
		var phantom = graphic.duplicate() as Node2D
		phantom.add_to_group("portal_phantom")
		add_child(phantom)
		phantoms.append(phantom)

		var rotate_angle = other_portal.angle - angle
		var in_to_graphic = graphic.global_position - start
		var out_to_phantom = in_to_graphic.rotated(rotate_angle)

		phantom.global_rotation = graphic.global_rotation + rotate_angle
		phantom.global_position = other_portal.start + flip(out_to_phantom)

		phantom.scale = flip(phantom.scale.rotated(phantom.global_rotation)).rotated(
			-phantom.global_rotation
		)
