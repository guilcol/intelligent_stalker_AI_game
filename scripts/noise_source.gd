extends Node2D

@onready var noise_circle = $noise_area/noise_circle
@onready var noise_area = $noise_area
@onready var timer = $timer
var nc_shape: CircleShape2D
var stalker: CharacterBody2D
var noise_type: String

func _ready() -> void:
	nc_shape = noise_circle.shape

func set_noise_type(type: String) -> void:
	noise_type = type

func set_radius(r: float) -> void:
	nc_shape.radius = r

func _on_noise_area_body_entered(body: Node2D) -> void:
	if body.name.substr(0,4) == "stlk":
		stalker = body
		stalker.hear_noise(global_position, noise_type)
		timer.start()

func _on_timer_timeout() -> void:
	if noise_area.overlaps_body(stalker):
		stalker.hear_noise(global_position, noise_type)
