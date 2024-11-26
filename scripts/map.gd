extends TileMapLayer

var player_start_pos = Vector2i(56, 56)
var stalker_start_pos = Vector2i(400, 272)
var rng = RandomNumberGenerator.new()

# Nodes
var preload_player = preload("res://scenes/player.tscn")
var preload_stalker = preload("res://scenes/stalker.tscn")

func _ready() -> void:
	var player: CharacterBody2D = preload_player.instantiate()
	var stalker: CharacterBody2D = preload_stalker.instantiate()
	player.global_position = player_start_pos
	stalker.global_position = stalker_start_pos
	add_child(player)
	add_child(stalker)

func _scatter_items(items_amount: int, items_pool: Array) -> void:
	pass
