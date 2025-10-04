extends RigidBody2D


func _process(delta: float) -> void:
	var water = get_node("/root/main/water")
	var idx = water.get_nearest_point_idx(global_position.x)
	if global_position.y > water.get_point_y(idx):
		water.splash_point(idx, linear_velocity.y)
		queue_free()
