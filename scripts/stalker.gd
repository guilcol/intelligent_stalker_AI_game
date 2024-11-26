extends CharacterBody2D

# Nodes
@onready var nav_agent := $NavigationAgent2D

const SPEED = 100.0
const MAX_HEARING_DISTANCE = 450.0

func _ready() -> void:
	nav_agent.max_speed = SPEED
	
func _physics_process(delta: float) -> void:
	#var dir = to_local(nav_agent.get_next_path_position()).normalized()
	#velocity = lerp(velocity, dir * SPEED, 0.1)
	move_and_slide()

func hear_noise(pos: Vector2, noise_type: String):
	nav_agent.target_position = pos
	to_local(nav_agent.get_next_path_position()).normalized()
	var path = nav_agent.get_current_navigation_path()
	var path_length = _get_path_length(path)
	
func _get_path_length(path: Array):
	var length = 0.0
	if path.size() < 2:
		return length
	for i in range(1, path.size()):
		length += path[i - 1].distance_to(path[i])
	return length
	
