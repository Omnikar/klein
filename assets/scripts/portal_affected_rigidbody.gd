class_name PortalAffectedRigidbody
extends PortalAffected


func _ready():
	transform_node = transform_node as RigidBody2D
	transform_node.gravity_scale = 0
	super._ready()


func _physics_process(delta: float):
	var gravity = ProjectSettings.get_setting("physics/2d/default_gravity_vector")
	if gravity != null:
		gravity = gravity.rotated(gravity_angle)
		# This seems like it should be `apply_central_force`, but
		# for whatever reason that makes it fall really slowly
		transform_node.apply_central_impulse(gravity * transform_node.mass)
	super._physics_process(delta)
