extends Area2D

var noise_level = 0.0 # [0.0, 1.0] 
@onready var noise_visual: Sprite2D = $noise_visual

func _ready() -> void:
	noise_visual.modulate.a = 0.0
	
func _process(delta: float) -> void:
	noise_visual.modulate.a = noise_level
	if noise_level > 0.0:
		noise_level -= 0.001
	
func set_noise_value(ld: float):
	noise_level = ld
	
func get_noise_value():
	return noise_level
