extends Node2D


@onready var tile_map : TileMap = $TileMap

# Preload nodes
var care_package_node = preload("res://models/care_package/care_package.tscn")
var basic_plant_node = preload("res://models/plants/basic_plant/basic_plant.tscn")
var zombie_node = preload("res://models/mobs/zombie/zombie.tscn")

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

var occupied_tiles = []


var rng = RandomNumberGenerator.new()
var care_package_spawn_time = rng.randf_range(60, 300)
var zombie_spawn_time = rng.randf_range(5, 10)

@onready
var money_manager = get_node("/root/MoneyManager")

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("UI").connect("farming_mode_changed", Callable(self, "_on_farming_mode_changed"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	spawn_care_package(delta)
	spawn_zombie(delta)

func _input(event):
	#Set mode
	if Input.is_action_just_pressed("toggle_hoe"):
		farming_mode = FARMING_MODES.TILL
	if Input.is_action_just_pressed("toggle_plant"):
		farming_mode = FARMING_MODES.PLANT
	
	if Input.is_action_just_pressed("left_click"):
			do_action()
			
			#tile_map.set_cell(plant_layer, tile_mouse_pos, plant_set_source, atlas_cord)	

# Spawn the care package in between 60 and 300 frames
func spawn_care_package(delta):
	care_package_spawn_time -= delta;
	if(care_package_spawn_time < 0):
		var care_package = care_package_node.instantiate()
		care_package.position = Vector2(randf_range(-100,100), randf_range(-100, 100))
		add_child(care_package)
		# Reset the care package spawn time
		care_package_spawn_time = rng.randf_range(60, 300)
		return
	return
	
# Spawn the care package in between 60 and 300 frames
func spawn_zombie(delta):
	zombie_spawn_time -= delta;
	if(zombie_spawn_time < 0):
		var zombie = zombie_node.instantiate()
		zombie.position = Vector2(randf_range(-100,100), randf_range(-100, 100))
		add_child(zombie)
		# Reset the care package spawn time
		zombie_spawn_time = rng.randf_range(3, 10)
		return
	return

func do_action():
		var mouse_pos = get_global_mouse_position()
		var tile_mouse_pos = tile_map.local_to_map(mouse_pos)
		#Hoeing ground
		if farming_mode == FARMING_MODES.TILL && retrieve_custom_data(tile_mouse_pos, can_till, ground_layer):
			var atlas_cord = Vector2i(0, 3) #the id of the tile we want to place
			tile_map.set_cell(ground_layer, tile_mouse_pos, ground_set_source, atlas_cord)
		if farming_mode == FARMING_MODES.PLANT && retrieve_custom_data(tile_mouse_pos, can_plant, ground_layer):
			var atlas_cord = Vector2i(0, 0) #the id of the tile we want to place
			if tile_mouse_pos*16+Vector2i(8,8) as Vector2 in occupied_tiles:
				return
			if(money_manager.buy(3)):
				var basic_plant = basic_plant_node.instantiate()
				print(tile_mouse_pos*16)
				basic_plant.position = tile_mouse_pos*16+Vector2i(8,8)
				add_child(basic_plant)
				occupied_tiles.append(basic_plant.position)
				free_occupied_tile(basic_plant.position)
	

func retrieve_custom_data(tile_mouse_pos, custom_data_layer, layer):
	var tile_data : TileData = tile_map.get_cell_tile_data(layer, tile_mouse_pos)
	if tile_data:
		return tile_data.get_custom_data(custom_data_layer)
	else:
		return false
		
func _on_farming_mode_changed(mode):
	# Update the farming mode variable based on the emitted signal
	if (mode == 2):
		farming_mode = FARMING_MODES.PLANT
	if (mode == 1):
		farming_mode = FARMING_MODES.TILL
		
		
func free_occupied_tile(plant_position):
	occupied_tiles.erase(plant_position)
