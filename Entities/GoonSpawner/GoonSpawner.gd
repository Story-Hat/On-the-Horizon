extends Node2D


var tilemap
var tree_tilemap

export var spawn_area : Rect2 = Rect2(0, 0, 700, 700)
export var max_goons = 40
export var start_goons = 1
var goon_count = 0
var goon_scene = preload("res://Entities/Goon/Goon.tscn")

var rng = RandomNumberGenerator.new()

func _ready():
	tilemap = get_tree().root.get_node("Root/TileMap")
	rng.randomize()
	
	for i in range(start_goons):
		instance_goon()
	goon_count = start_goons

func instance_goon():
	#Instance goon scene and add it to the scene tree
	var goon = goon_scene.instance()
	add_child(goon)
	
	var valid_position = false
	while not valid_position:
		goon.position.x = spawn_area.position.x + rng.randf_range(0, spawn_area.size.x)
		goon.position.y = spawn_area.position.y + rng.randf_range(0, spawn_area.size.y)
		valid_position = test_position(goon.position)
	#goon.set_scale(Vector2(rng.randf_range(.1, 1), rng.randf_range(.1, 1)))
	goon.arise()
	
	
func test_position(position : Vector2):
	#Check if the cell type in position is floor
	var cell_coord = tilemap.world_to_map(position)
	var cell_type_id = tilemap.get_cellv(cell_coord)
	var isFloor = (cell_type_id == tilemap.tile_set.find_tile_by_name("floor0.png 6"))
	
	return isFloor


func _on_Timer_timeout():
	if goon_count < max_goons:
		instance_goon()
		goon_count = goon_count + 1
