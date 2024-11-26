extends Area2D

var item_name: String
@onready var sprite: Sprite2D = $item_sprite

func construct_dropped_item(n: String) -> void:
	item_name = n
	# the naming convention for items will be NAME_item
	# the naming convention for item sprites will be NAME_item_sprite 
	var image_path = "res://art/items/" + item_name + "_item_sprite.png"
	var sprite_texture = load(image_path)
	sprite.texture = sprite_texture

func _on_body_entered(body: Node2D) -> void:
	if body.name.substr(0,4) == "plyr":
		var obj_path = "res://scenes/items/" + item_name + "_item.tscn"
		var item_obj = load(obj_path)
		var item_obj_instance = item_obj.instance()
		body.collect_item(item_obj_instance)
