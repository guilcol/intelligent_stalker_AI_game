extends Node2D

@onready var map: TileMapLayer = null
var preload_tile_node = preload("res://scenes/tile_node.tscn")
var preload_player = preload("res://scenes/player.tscn")
var tile_dict = {} # Vector2i(x, y): Tile Object Ref#

func _ready() -> void:
	_find_map_node()
	_populate_tiles()
	
	# NOISE DEBUG ---
	var noise_map = Node2D.new()
	_populate_noise_map()
	# NOISE DEBUG ---

func _populate_noise_map():
	pass
	
func _populate_tiles():
	var tile_coords = Node2D.new()
	var tiles = map.get_used_cells()
	var wall = Vector2i(0, 0)
	for tile in tiles:
		if map.get_cell_atlas_coords(tile) != wall:
			var tile_node = preload_tile_node.instantiate()
			var calc_pos = tile * 32
			var tile_pos = Vector2i(calc_pos.x + 16, calc_pos.y + 16)
			tile_node.name = "tile_node" + str(tile_pos)
			tile_node.global_position = tile_pos
			tile_coords.add_child(tile_node)
			tile_dict[tile_pos] = tile_node
	map.add_child(tile_coords)
	var player: CharacterBody2D = preload_player.instantiate()
	player.global_position = map.get_start_pos()
	map.add_child(player)

func get_tile_dict():
	return tile_dict

func _find_map_node():
	var children = get_children()
	for child in children:
		if child is TileMapLayer:
			map = child
			break
