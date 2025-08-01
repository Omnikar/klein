class_name PortalAffected extends PortalDisplayed

@export var transform_node: Node2D
@export_range(-180, 180, 0.1, "radians_as_degrees") var reflect_axis_angle: float = PI / 2

var last_pos: Vector2
var this_pos: Vector2

var flipped: bool = false
var gravity_angle: float = 0


func _ready():
	reset_pos_history()
	add_to_group("portal_affected")


func reset_pos_history():
	last_pos = transform_node.global_position
	this_pos = transform_node.global_position


func _physics_process(_delta: float):
	last_pos = this_pos
	this_pos = transform_node.global_position


func portal_intersect(start: Vector2, end: Vector2):
	# return Geometry2D.segment_intersects_segment(last_pos, this_pos, start, end)
	var out = Geometry2D.segment_intersects_segment(last_pos, this_pos, start, end)
	if not out == null:
		print("last_pos: ", last_pos)
		print("this_pos: ", this_pos)
		print("start: ", start)
		print("end: ", end)
	return out


func set_rotation(rot: float):
	var diff = rot - gravity_angle
	rotate(diff)


func rotate(rot: float):
	gravity_angle += rot
	transform_node.rotation += rot
