extends Control

var coin_counter_label

signal farming_mode_changed(mode)

@onready
var money_manager = get_node("/root/MoneyManager")
# Called when the node enters the scene tree for the first time.

@onready var till_button = get_node("GridContainer/till_button")  # Replace with the actual names of your buttons
@onready var plant_button = get_node("GridContainer/plant")  # Replace with the actual names of your buttons

var mode = 2

var original_till
var original_plant
var selected_till
var selected_plant


func _ready():
	money_manager.connect("update_coin_ui_value", Callable(self, "_on_update_coin_ui_value"))
	original_till = preload("res://ui/img/hoe.png")
	original_plant = preload("res://ui/img/seed.jpg")
	selected_till = preload("res://ui/img/theselectedhoe.png")
	selected_plant = preload("res://ui/img/theselectedseed.jpg")
	
	coin_counter_label = get_node("coin_counter")
	coin_counter_label.text = "Coins: " + str(money_manager.get_coins())

	till_button.connect("pressed", Callable(self, "_on_till_button_pressed"))
	plant_button.connect("pressed",Callable( self, "_on_plant_button_pressed"))
	

	
func _on_update_coin_ui_value(coins):
	coin_counter_label.text = "Coins: " + str(coins)

#najdi go nodeto, napraj seting na mode kako na radio button, treba i da go definiras kako signal
func set_farming_mode():
	# Emit a signal to indicate a change in farming mode
	farming_mode_changed.emit(mode)
	
func _on_till_button_pressed():
	# Set the farming mode to TILL when the TILL button is pressed
	mode = 1
	set_farming_mode()
	till_button.texture_normal=selected_till
	plant_button.texture_normal=original_plant


	#plant_button.pressed = false  # Deselect the PLANT button
func _input(event):
	#Set mode
	if Input.is_action_just_pressed("toggle_hoe"):
		_on_till_button_pressed()
	if Input.is_action_just_pressed("toggle_plant"):
		_on_plant_button_pressed()

func _on_plant_button_pressed():
	# Set the farming mode to PLANT when the PLANT button is pressed
	mode = 2
	set_farming_mode()
	till_button.texture_normal=original_till
	plant_button.texture_normal=selected_plant
	#till_button.pressed = false  # Deselect the TILL button
	
