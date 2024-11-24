extends CharacterBody2D

# Nodes
@onready var map: TileMapLayer = get_parent()
@onready var camera: Camera2D = $camera
@onready var world_node = get_parent().get_parent()
@onready var cast = $raycast

# Movement
const SPEED = 120.0
var real_direction = Vector2(0, 0)
var direction = Vector2(0, 0)
var speed_modifier = 1

# Noise
var loudness: float = 5.0

# UI 
var UI = null
var stamina_bar: TextureProgressBar = null
var stamina: float = 50.0
var stamina_loss: float = 0.25
var stamina_gain: float = 0.3

# Other
var tile_dict: Dictionary = {}

func _physics_process(delta: float) -> void:
	var speed_mod_axis = Input.get_axis("crouch", "sprint")
	if speed_mod_axis > 0:
		if stamina > 0.0:
			loudness = 8.0
			speed_modifier = 1.65
			stamina -= stamina_loss
		else:
			loudness = 5.0
			speed_modifier = 1
	elif speed_mod_axis < 0:
		loudness = 3.0
		speed_modifier = 0.4
		if stamina < 50:
			stamina += stamina_gain
	else:
		speed_modifier = 1
		loudness = 5.0
		if stamina < 50:
			stamina += stamina_gain
			
	stamina_bar.value = int(stamina)
	
	real_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if real_direction != Vector2(0, 0):
		direction = lerp(direction, real_direction * speed_modifier, 0.1)
	else:
		direction = lerp(direction, Vector2(0, 0), 0.3)
	if direction:
		velocity = direction * SPEED
	else:
		velocity = Vector2(0, 0)
	move_and_slide()
	
func _ready() -> void:
	_set_camera_limits()
	_get_UI_components()
	tile_dict = world_node.get_tile_dict()

func _get_UI_components():
	UI = _find_child_by_name("UI", world_node.get_children())
	stamina_bar = _find_child_by_name("stamina_bar", UI.get_children())

func _set_camera_limits() -> void:
	var map_rect = map.get_used_rect()
	var tile_size = 32
	var map_size = map_rect.size * tile_size
	camera.limit_left = 0
	camera.limit_top = 0
	camera.limit_bottom = map_size.y
	camera.limit_right = map_size.x
	
func _find_child_by_name(name: String, children):
	for child in children:
		if child.name == name:
			return child
	return null
		

func _on_player_area_area_entered(area: Area2D) -> void:
	if area.name.substr(0, 9) == "tile_node":
		var pos = Vector2i(area.global_position)
		_manifest_noise_2(pos)

func _manifest_noise_2(pos):
	var start_x = pos.x - (loudness * 32)
	var start_y = pos.y - (loudness * 32)
	var end_x = pos.x + (loudness * 32)
	var end_y = pos.y + (loudness * 32)
	
	for y in range(start_y, end_y, 32):
		for x in range(start_x, end_x, 32):
			var curr_pos = Vector2i(x, y)
			if curr_pos in tile_dict:
				var dist = _get_distance_to_tile(curr_pos)
				if dist <= 32 * loudness:
					cast.target_position = Vector2(curr_pos) - global_position
					cast.force_raycast_update()
					if not cast.is_colliding():
						tile_dict[curr_pos].set_noise_value(1 - (dist / (32 * loudness)))

func _get_distance_to_tile(pos: Vector2i) -> float:
	var x1 = int(global_position.x / 32) * 32
	var y1 = int(global_position.y / 32) * 32
	var x2 = pos.x - 16
	var y2 = pos.y - 16
	var dist = sqrt(pow(x2-x1, 2)+pow(y2-y1, 2))
	return dist
	
func _manifest_noise(pos: Vector2i, ld: float):
	if pos not in tile_dict:
		return null
	var tile_node = tile_dict[pos]
	if tile_node.get_noise_value() > ld:
		return null
	tile_node.set_noise_value(ld)
	var new_pos = Vector2i(pos.x + 32, pos.y)
	#_manifest_noise(new_pos, ld - noise_dissipation)
	new_pos = Vector2i(pos.x - 32, pos.y)
	#_manifest_noise(new_pos, ld - noise_dissipation)
	new_pos = Vector2i(pos.x, pos.y + 32)
	#_manifest_noise(new_pos, ld - noise_dissipation)
	new_pos = Vector2i(pos.x, pos.y - 32)
	#_manifest_noise(new_pos, ld - noise_dissipation)
	

	
	
