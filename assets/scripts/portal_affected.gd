class_name PortalAffected extends PortalPhantomed

@export var transform_node: Node2D
@export_range(-180, 180, 0.1, "radians_as_degrees") var reflect_axis_angle: float = PI / 2
@export_range(-180, 180, 0.1, "radians_as_degrees") var gravity_angle: float = 0:
	get():
		return gravity_angle
	set(value):
		gravity_angle = value
@export var flipped: bool = false

@export var enabled: bool = true:
	get():
		return enabled
	set(new):
		enabled = new
		if enabled:
			add_to_group("portal_affected")
		else:
			remove_from_group("portal_affected")

var last_pos: Vector2
var this_pos: Vector2


func _ready() -> void:
	reset_pos_history()
	enabled = enabled
	super._ready()


func reset_pos_history() -> void:
	last_pos = transform_node.global_position
	this_pos = transform_node.global_position


func _physics_process(_delta: float) -> void:
	last_pos = this_pos
	this_pos = transform_node.global_position


func portal_intersect(start: Vector2, end: Vector2) -> Variant:
	# return Geometry2D.segment_intersects_segment(last_pos, this_pos, start, end)
	var out = Geometry2D.segment_intersects_segment(last_pos, this_pos, start, end)
	if not out == null:
		# print("last_pos: ", last_pos)
		# print("this_pos: ", this_pos)
		# print("start: ", start)
		# print("end: ", end)
		pass
	return out


func set_rotation(rot: float) -> void:
	var diff = rot - gravity_angle
	rotate(diff)


func rotate(rot: float) -> void:
	gravity_angle += rot
	transform_node.rotation += rot
