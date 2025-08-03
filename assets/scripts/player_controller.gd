@tool
class_name PlayerController extends CharacterBody2D

@export var jump_sfx: AudioStreamPlayer
@export var step_sfx: AudioStreamPlayer

@export var speed = 50.0
@export var jump_vel = 130.0
@export var max_y_speed = 500.0
@export var flipped = false:
	get():
		return $PortalAffected.flipped
	set(value):
		$PortalAffected.flipped = value
@export var mass = 6

var vertical: bool:
	get():
		return abs(cos(rotation)) < 0.01

var last_flipped: bool
var last_direction: float = 0
var last_vertical: bool
var flipped_since_last_dir_change: bool = false

# var nearby_interactables: Dictionary = {}

var carry_point_pos: Vector2
var nearby_carryables: Dictionary = {}
var carry: Carryable = null
var carry_orig_parent: Node = null
var carry_grav_dir_diffs: Array = []
var carry_flip_diffs: Array = []

var total_mass: float:
	get():
		if carry == null:
			return mass
		else:
			return mass + carry.mass


func _ready() -> void:
	if not Engine.is_editor_hint():
		last_flipped = $PortalAffected.flipped
		$PortalAffected.gravity_angle = rotation
		carry_point_pos = $CarryPoint.position
		last_vertical = vertical


func update_up_direction() -> void:
	up_direction = Vector2.UP.rotated(rotation)


var right: Vector2:
	get():
		return Vector2.RIGHT.rotated(rotation)

var down: Vector2:
	get():
		return Vector2.DOWN.rotated(rotation)


func set_relative_x_vel(vel: float) -> void:
	var y_part = velocity.project(down)
	var x_part = vel * right
	velocity = x_part + y_part


func set_relative_y_vel(vel: float) -> void:
	var x_part = velocity.project(right)
	var y_part = vel * down
	velocity = x_part + y_part


func relative_x_vel() -> float:
	return velocity.dot(right)


func relative_y_vel() -> float:
	return velocity.dot(down)


func _process(_delta: float) -> void:
	$InteractIndicator.visible = not nearby_carryables.is_empty() and carry == null
	$InteractIndicator.global_rotation = 0


func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return

	update_up_direction()
	handle_movement(delta)
	handle_carry()


func handle_movement(delta: float) -> void:
	if flipped != last_flipped:
		last_direction *= -1
		flipped_since_last_dir_change = true
	if vertical != last_vertical:
		flipped_since_last_dir_change = true
	last_flipped = flipped
	last_vertical = vertical

	# Add the gravity.
	if not is_on_floor():
		# velocity += get_gravity().rotated(rotation) * delta
		var total_gravity = get_gravity().rotated(rotation) * mass
		if carry != null:
			# var pa = find_portal_affecteds(carry)
			# if not pa.is_empty():
			# 	var carry_gravity = carry.mass * get_gravity().rotated(pa[0].gravity_angle)
			# 	total_gravity += carry_gravity
			for dir_diff in carry_grav_dir_diffs:
				var carry_gravity = carry.mass * get_gravity().rotated(rotation + dir_diff)
				total_gravity += carry_gravity
		velocity += total_gravity * delta / total_mass

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		set_relative_y_vel(-jump_vel)
		jump_sfx.play()
		# var momentum = -jump_vel * mass
		# set_relative_y_vel(momentum / total_mass)

	var y_vel = relative_y_vel()
	if abs(y_vel) > max_y_speed:
		set_relative_y_vel(sign(y_vel) * max_y_speed)

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("move_left", "move_right")
	if last_direction != 0 and direction != 0 and flipped_since_last_dir_change:
		direction = last_direction
	elif cos(rotation) < -0.01:
		direction *= -1
	if direction:
		set_relative_x_vel(direction * speed)
		# var momentum = direction * speed * mass
		# set_relative_x_vel(momentum / total_mass)
	else:
		set_relative_x_vel(move_toward(relative_x_vel(), 0, speed))

	if direction != last_direction:
		flipped_since_last_dir_change = false
	last_direction = direction

	move_and_slide()
	
	if abs(relative_x_vel()) > 0.001:
		if !step_sfx.playing:
			step_sfx.play()
	else:
		step_sfx.stop()
	
# FIXME: Doesn't correctly handle rotation/flipping of carried object
func handle_carry() -> void:
	$CarryPoint.position = carry_point_pos.reflect(Vector2.DOWN) if flipped else carry_point_pos
	if carry != null:
		carry.position = Vector2.ZERO
	# Not sure if this is necessary
	# if flipped != last_flipped and carry != null:
	# 	carry.scale.y *= -1

	if Input.is_action_just_pressed("interact"):
		if carry == null:
			if not nearby_carryables.is_empty():
				carry = nearby_carryables.keys()[0]
				carry_orig_parent = carry.get_parent()
				carry_grav_dir_diffs = find_portal_affecteds(carry).map(
					func(pa): return pa.gravity_angle - $PortalAffected.gravity_angle
				)
				carry_flip_diffs = find_portal_affecteds(carry).map(
					func(pa): return pa.flipped != flipped
				)
				var carry_momentum = carry.linear_velocity * carry.mass
				var own_momentum = velocity * mass
				velocity = (own_momentum + carry_momentum) / total_mass
				set_portal_affecteds_enabled(carry, false)
				carry.reparent($CarryPoint)
				carry.position = Vector2.ZERO
				carry.freeze = true
		else:
			carry.reparent(carry_orig_parent)
			# carry.set_linear_velocity(velocity * 0.5)
			carry.set_linear_velocity(Vector2.ZERO)
			carry.set_angular_velocity(0)
			set_portal_affecteds_enabled(carry, true)
			var portal_affecteds = find_portal_affecteds(carry)
			for i in range(portal_affecteds.size()):
				portal_affecteds[i].last_pos = global_position
				portal_affecteds[i].this_pos = carry.global_position
				var grav_dir_diff = carry_grav_dir_diffs[i]
				var flip = flipped != carry_flip_diffs[i]
				# I think this is right, not sure
				if flip:
					grav_dir_diff *= -1
				portal_affecteds[i].gravity_angle = $PortalAffected.gravity_angle + grav_dir_diff
				portal_affecteds[i].flipped = flip
			carry.freeze = false
			carry = null
			carry_orig_parent = null
			carry_grav_dir_diffs = []
			carry_flip_diffs = []


func approach_object(obj: Node2D) -> void:
	var carryable = Utils.find_ancestor(obj, func(n): return n is Carryable)
	if carryable != null:
		nearby_carryables[carryable] = null
	# var interactable = Utils.find_ancestor(obj, func(n): return n is Interactable or n is Carryable)
	# if interactable != null:
	# 	nearby_interactables[interactable] = null


func leave_object(obj: Node2D) -> void:
	var carryable = Utils.find_ancestor(obj, func(n): return n is Carryable)
	if carryable != null:
		nearby_carryables.erase(carryable)
	# var interactable = Utils.find_ancestor(obj, func(n): return n is Interactable or n is Carryable)
	# if interactable != null:
	# 	nearby_interactables.erase(interactable)


func find_portal_affecteds(parent: Node) -> Array:
	return parent.find_children("*", "PortalAffected") as Array[PortalAffected]


func set_portal_affecteds_enabled(parent: Node, enabled: bool) -> void:
	for portal_affected in find_portal_affecteds(parent):
		portal_affected.enabled = enabled
