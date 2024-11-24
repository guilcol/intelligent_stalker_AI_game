extends CharacterBody2D

# Nodes
@onready var map: TileMapLayer = get_parent()
@onready var camera: Camera2D = $camera
@onready var world_node = get_parent().get_parent()

# Movement
const SPEED = 120.0
var real_direction = Vector2(0, 0)
var direction = Vector2(0, 0)
var speed_modifier = 1

# Noise
var noise_dissipation: float = 0.2

# UI 
var UI = null
var stamina_bar: TextureProgressBar = null
var stamina = 50.0
var stamina_loss = 0.25
var stamina_gain = 0.3

# Other
var tile_dict: Dictionary = {}

func _physics_process(delta: float) -> void:
	var speed_mod_axis = Input.get_axis("crouch", "sprint")
	if speed_mod_axis > 0:
		if stamina > 0.0:
			speed_modifier = 1.65
			stamina -= stamina_loss
			noise_dissipation = 0.15
		else:
			speed_modifier = 1
			noise_dissipation = 0.2 
	elif speed_mod_axis < 0:
		speed_modifier = 0.4
		noise_dissipation = 0.35
		if stamina < 50:
			stamina += stamina_gain
	else:
		speed_modifier = 1
		noise_dissipation = 0.2
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
		_manifest_noise(pos, 1)
		
func _manifest_noise(pos: Vector2i, ld: float):
	if pos not in tile_dict:
		return null
	var tile_node = tile_dict[pos]
	if tile_node.get_noise_value() > ld:
		return null
	tile_node.set_noise_value(ld)
	var new_pos = Vector2i(pos.x + 32, pos.y)
	_manifest_noise(new_pos, ld - noise_dissipation)
	new_pos = Vector2i(pos.x - 32, pos.y)
	_manifest_noise(new_pos, ld - noise_dissipation)
	new_pos = Vector2i(pos.x, pos.y + 32)
	_manifest_noise(new_pos, ld - noise_dissipation)
	new_pos = Vector2i(pos.x, pos.y - 32)
	_manifest_noise(new_pos, ld - noise_dissipation)
	
	
