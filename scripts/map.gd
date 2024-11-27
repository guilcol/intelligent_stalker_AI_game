extends TileMapLayer

var player_start_pos = Vector2i(56, 56)
var stalker_start_pos = Vector2i(400, 272)
var rng = RandomNumberGenerator.new()

# Nodes
var preload_player = preload("res://scenes/player.tscn")
var preload_stalker = preload("res://scenes/stalker.tscn")
@onready var player_manager: Node2D = null

func _ready() -> void:
	var player: CharacterBody2D = preload_player.instantiate()
	var stalker: CharacterBody2D = preload_stalker.instantiate()
	player.global_position = player_start_pos
	stalker.global_position = stalker_start_pos
	player.name = "plyr" + str(player.get_rid())
	stalker.name = "stlk" + str(stalker.get_rid())
	add_child(player)
	add_child(stalker)

func _scatter_items(items_amount: int, items_pool: Array) -> void:
	pass
	
func _find_player_manager():
	var parent = get_parent()
	var siblings = parent.get_children()
	for sib in siblings:
		if sib.name == "":
			pass
