class_name PlayerController
extends CharacterBody2D

@export var speed = 50.0
@export var jump_vel = 140.0

var last_flipped: bool
var last_direction: float = 0


func _ready():
	last_flipped = $PortalAffected.flipped


func update_up_direction():
	up_direction = Vector2.UP.rotated(rotation)


func right() -> Vector2:
	return Vector2.RIGHT.rotated(rotation)


func down() -> Vector2:
	return Vector2.DOWN.rotated(rotation)


func set_relative_x_vel(vel: float):
	var y_part = velocity.project(down())
	var x_part = vel * right()
	velocity = x_part + y_part


func set_relative_y_vel(vel: float):
	var x_part = velocity.project(right())
	var y_part = vel * down()
	velocity = x_part + y_part


func relative_x_vel() -> float:
	return velocity.dot(right())


func relative_y_vel() -> float:
	return velocity.dot(down())


func _physics_process(delta: float):
	update_up_direction()

	var flipped = $PortalAffected.flipped
	if flipped != last_flipped:
		last_direction *= -1
	last_flipped = flipped

	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity().rotated(rotation) * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		set_relative_y_vel(-jump_vel)

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("move_left", "move_right")
	if last_direction != 0 and direction != 0:
		direction = last_direction
	elif cos(rotation) < -0.01:
		direction *= -1
	if direction:
		set_relative_x_vel(direction * speed)
	else:
		set_relative_x_vel(move_toward(relative_x_vel(), 0, speed))

	last_direction = direction

	move_and_slide()
