extends Node2D


var point_count = 192
var base_y_pos = 800.0
var restore_force = 50.0
var damping = 0.98
var spread = 0.1
var water_points_y = []
var water_points_v = []
@onready var line_2d: Line2D = $Line2D
@onready var polygon_2d: Polygon2D = $Polygon2D
@onready var SCREEN_SIZE : Vector2 = get_viewport().size


func _ready() -> void:
	for i in range(point_count):
		water_points_y.append(base_y_pos)
		water_points_v.append(0)


func _process(delta: float) -> void:
	draw_water()
	calc_point_phys(delta)
	
	
func draw_water() -> void:
	var points: PackedVector2Array = PackedVector2Array()
	var seg_width : float = SCREEN_SIZE.x / (point_count - 1)
	
	for i in range(point_count):
		points.append(Vector2(i * seg_width, water_points_y[i]))
	line_2d.points = points
	points.append(SCREEN_SIZE)
	points.append(Vector2(0.0, SCREEN_SIZE.y))
	polygon_2d.polygon = points


func get_nearest_point_idx(x_pos : float) -> int:
	var seg_width : float = SCREEN_SIZE.x / (point_count - 1)
	return round(x_pos / seg_width)
	

func get_point_y(idx : int) -> float:
	return water_points_y[idx]


func splash_point(idx: int, drop_v: float) -> void:
	drop_v = min(drop_v, 300.0)
	water_points_v[idx] += drop_v * 0.875
	if idx > 2:
		water_points_v[idx - 1] += drop_v * 0.75
		water_points_v[idx - 2] += drop_v * 0.5
		water_points_v[idx - 3] += drop_v * 0.25
	if idx < point_count - 3:
		water_points_v[idx + 1] += drop_v * 0.75
		water_points_v[idx + 2] += drop_v * 0.5
		water_points_v[idx + 3] += drop_v * 0.25

func calc_point_phys(delta) -> void:
	for i in range(point_count):
		water_points_y[i] += water_points_v[i] * delta
		var force = (base_y_pos - water_points_y[i]) * restore_force
		water_points_v[i] += force * delta
		water_points_v[i] *= damping
	
	var new_pos = water_points_y.duplicate()
	for i in range(1, point_count-1):
		new_pos[i] += (water_points_y[i-1] - water_points_y[i]) * spread
		new_pos[i] += (water_points_y[i+1] - water_points_y[i]) * spread
	
	for i in range(1, point_count-1):
		water_points_y[i] = new_pos[i]
