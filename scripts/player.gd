extends CharacterBody2D

# Nodes
@onready var map: TileMapLayer = get_parent()
@onready var camera: Camera2D = $camera
@onready var world_node = get_parent().get_parent()
@onready var cast = $raycast
@onready var walking_sound = $walking_sound
@onready var crouching_sound = $crouching_sound
@onready var sprinting_sound = $sprinting_sound

# Preloads
@export var ns_scene = preload("res://scenes/noise_source.tscn")
var ns_player: Node2D = null

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

func _ready() -> void:
	ns_player = ns_scene.instantiate()
	ns_player.name = "noise_source_player"
	ns_player.set_noise_type("steps")
	add_child(ns_player)
	_set_camera_limits()
	_get_UI_components()
	
func _physics_process(delta: float) -> void:
	
	var speed_mod_axis = Input.get_axis("crouch", "sprint")
	if speed_mod_axis > 0: # Sprinting
		if stamina > 0:
			isolate_sound("s")
			loudness = 8.0
			speed_modifier = 1.65
			stamina -= stamina_loss
		else:
			isolate_sound("w")
			loudness = 5.0
			speed_modifier = 1
	elif speed_mod_axis < 0: # Crouching
		isolate_sound("c")
		loudness = 3.0
		speed_modifier = 0.4
		stamina = min(50, stamina + stamina_gain)
	else: # Normal movement
		isolate_sound("w")
		loudness = 5.0
		speed_modifier = 1
		stamina = min(50, stamina + stamina_gain)
	if stamina < 0.5 and speed_mod_axis > 0:
		speed_modifier = 1
		loudness = 5.0	
	stamina_bar.value = int(stamina)
	
	real_direction = _get_direction_vector()
	if real_direction != Vector2(0, 0):
		direction = lerp(direction, real_direction * speed_modifier, 0.1)
	else:
		direction = lerp(direction, Vector2(0, 0), 0.3)
		walking_sound.stop()
		crouching_sound.stop()
		sprinting_sound.stop()
	if direction:
		velocity = direction * SPEED
	else:
		velocity = Vector2(0, 0)
	var real_speed = clamp(velocity.length() / (SPEED * 1.65), 0.0, 1.0)
	_update_noise(real_speed)
	move_and_slide()

func _get_direction_vector() -> Vector2:
	var wasd_vector = Input.get_vector("left", "right", "up", "down")
	var arrows_vector = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if not wasd_vector and arrows_vector:
		return arrows_vector
	if not arrows_vector and wasd_vector:
		return wasd_vector
	return ((wasd_vector + arrows_vector) / 2).normalized()
	
func _update_noise(val: float):
	var loudest = 280
	var curr_loudness = loudest * val
	ns_player.set_radius(curr_loudness)

func collect_item(item: Node2D):
	pass
	
func isolate_sound(type: String):
	if type == "w":
		sprinting_sound.stop()
		crouching_sound.stop()
		if not walking_sound.playing:
			walking_sound.play()
	elif type == "c":
		sprinting_sound.stop()
		walking_sound.stop()
		if not crouching_sound.playing:
			crouching_sound.play()
	else:
		walking_sound.stop()
		crouching_sound.stop()
		if not sprinting_sound.playing:
			sprinting_sound.play()

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
		
func _get_distance_to_tile(pos: Vector2i) -> float:
	var x1 = int(global_position.x / 32) * 32
	var y1 = int(global_position.y / 32) * 32
	var x2 = pos.x - 16
	var y2 = pos.y - 16
	var dist = sqrt(pow(x2-x1, 2)+pow(y2-y1, 2))
	return dist
