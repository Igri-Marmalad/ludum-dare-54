extends Node2D


@onready var tile_map : TileMap = $TileMap


@onready
var money_manager = get_node("/root/MoneyManager")

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

#mode enums
enum FARMING_MODES {TILL, PLANT, PICK}
enum PLANT_TYPES {BASIC, FAST, SLOW, OTHER}

#setting the mode that opens when u start the game
var farming_mode = FARMING_MODES.TILL
var plant_mode = PLANT_TYPES.BASIC


#preloading resources
var basic_plant = preload("res://models/plants/basic_plant/basic_plant.tscn")
var fast_plant = preload("res://models/plants/fast_plant/fast_plant.tscn")
var slow_plant = preload("res://models/plants/slow_plant/slow_plant.tscn")
var other_plant = preload("res://models/plants/other_plant/other_plant.tscn")

#for cursor images
var original_till = preload("res://ui/img/hoe.png")
var original_plant = preload("res://ui/img/seed.png")
var original_pick = preload("res://ui/img/pick.png")

#plant inits dictiornary
var plant_classes = {
	   			PLANT_TYPES.BASIC: basic_plant,
	  			PLANT_TYPES.FAST: fast_plant,
				PLANT_TYPES.SLOW: slow_plant,
				PLANT_TYPES.OTHER: other_plant
				}

var occupied_tiles = []


var rng = RandomNumberGenerator.new()
var care_package_spawn_time = rng.randf_range(60, 300)
var zombie_spawn_time = rng.randf_range(30, 120)


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("UI").connect("farming_mode_changed", Callable(self, "_on_farming_mode_changed"))

	get_node("UI").connect("seed_signal", Callable(self, "_on_signal_seed_changed"))

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
	if Input.is_action_just_pressed("toggle_pick"):
		farming_mode = FARMING_MODES.PICK
	if Input.is_action_just_pressed("left_click"):
			do_action()
			

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
		zombie_spawn_time = rng.randf_range(30, 120)
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
			
			if tile_mouse_pos * 16 + Vector2i(8, 8) as Vector2 in occupied_tiles:
				return
			
			if(money_manager.buy(3)):

				var selected_plant_class = plant_classes.get(plant_mode)
	
				if selected_plant_class:
					var plant = selected_plant_class.instantiate()
					print(tile_mouse_pos * 16)
					plant.position = tile_mouse_pos * 16 + Vector2i(8, 8)
					plant.connect("free_space", Callable(self, "free_occupied_tile"))
					add_child(plant)
					occupied_tiles.append(plant.position)
					


func retrieve_custom_data(tile_mouse_pos, custom_data_layer, layer):
	var tile_data : TileData = tile_map.get_cell_tile_data(layer, tile_mouse_pos)
	if tile_data:
		return tile_data.get_custom_data(custom_data_layer)
	else:
		return false
		
func _on_farming_mode_changed(mode):
	# Update the farming mode variable based on the emitted signal
	match mode:
		1:
			farming_mode = FARMING_MODES.TILL
			Input.set_custom_mouse_cursor(original_till, Input.CURSOR_ARROW, Vector2(0, 0))
			money_manager.lock()
		2:
			farming_mode = FARMING_MODES.PLANT
			Input.set_custom_mouse_cursor(original_plant, Input.CURSOR_ARROW, Vector2(0, 0))
			money_manager.lock()
		3:
			farming_mode = FARMING_MODES.PICK
			money_manager.unlock()
			Input.set_custom_mouse_cursor(original_pick, Input.CURSOR_ARROW, Vector2(0, 0))

func _on_signal_seed_changed(mode):
	match mode:
		1:
			plant_mode = PLANT_TYPES.BASIC
		2:
			plant_mode = PLANT_TYPES.SLOW
		3:
			plant_mode = PLANT_TYPES.FAST
		4:
			plant_mode = PLANT_TYPES.OTHER

		
func free_occupied_tile(plant_position):
	occupied_tiles.erase(plant_position)

