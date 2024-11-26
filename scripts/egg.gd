extends Node2D

var pos_x = 0.0
var is_thrown = false

func _process(delta: float) -> void:
	if is_thrown:
		pos_x += 0.1
		position = Vector2(pos_x, position.y)

func get_thrown(target_pos: Vector2):
	is_thrown = true
