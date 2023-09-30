extends Node2D

@onready var tile_map : TileMap = $TileMap

var ground_layer = 1
var plant_layer = 2


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	
func _input(event):
	#Hoeing ground
	if Input.is_action_just_pressed("left_click"):
		var mouse_pos = get_global_mouse_position()
		var tile_mouse_pos = tile_map.local_to_map(mouse_pos)
		
		var source_id = 0 #the id of the tileset
		var atlas_cord = Vector2i(0, 3) #the id of the tile we want to place
		
		tile_map.set_cell(ground_layer, tile_mouse_pos, source_id, atlas_cord)
	#Planting crops	
	if Input.is_action_just_pressed("right_click"):
		var mouse_pos = get_global_mouse_position()
		var tile_mouse_pos = tile_map.local_to_map(mouse_pos)
		
		var source_id = 2 #the id of the tileset
		var atlas_cord = Vector2i(0, 0) #the id of the tile we want to place
		
		tile_map.set_cell(plant_layer, tile_mouse_pos, source_id, atlas_cord)
