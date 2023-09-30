extends Node2D

@onready var tile_map : TileMap = $TileMap

#id of the tilemap layer
var ground_layer = 1
var plant_layer = 2

#Id of the tileset
var ground_set_source = 0
var plant_set_source = 2

#custom_layers
var can_till = "can_till"
var can_plant = "can_plant"

enum FARMING_MODES {TILL, PLANT}

var farming_mode = FARMING_MODES.TILL

var basic_plant = preload("res://models/plants/basic_plant/basic_plant.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _input(event):
	#Set mode
	if Input.is_action_just_pressed("toggle_hoe"):
		farming_mode = FARMING_MODES.TILL
	if Input.is_action_just_pressed("toggle_plant"):
		farming_mode = FARMING_MODES.PLANT
	
	
	if Input.is_action_just_pressed("left_click"):
		var mouse_pos = get_global_mouse_position()
		var tile_mouse_pos = tile_map.local_to_map(mouse_pos)
		#Hoeing ground
		if farming_mode == FARMING_MODES.TILL && retrieve_custom_data(tile_mouse_pos, can_till, ground_layer):
			var atlas_cord = Vector2i(0, 3) #the id of the tile we want to place
			tile_map.set_cell(ground_layer, tile_mouse_pos, ground_set_source, atlas_cord)
		if farming_mode == FARMING_MODES.PLANT && retrieve_custom_data(tile_mouse_pos, can_plant, ground_layer):
			var atlas_cord = Vector2i(0, 0) #the id of the tile we want to place
			var plant = basic_plant.instantiate()
			print(tile_mouse_pos*16)
			plant.position = tile_mouse_pos*16+Vector2i(8,8)
			add_child(plant)
			#tile_map.set_cell(plant_layer, tile_mouse_pos, plant_set_source, atlas_cord)	


func retrieve_custom_data(tile_mouse_pos, custom_data_layer, layer):
	var tile_data : TileData = tile_map.get_cell_tile_data(layer, tile_mouse_pos)
	if tile_data:
		return tile_data.get_custom_data(custom_data_layer)
	else:
		return false
		
