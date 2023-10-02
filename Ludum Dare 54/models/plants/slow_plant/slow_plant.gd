extends Node2D

# Reference to the Sprite and Timer nodes
var sprite_node
var timer_node
var loading_bar
var timer_node_2

@onready
var money_manager = get_node("/root/MoneyManager")
# Variables for smooth loading bar interpolation

var current_progress = 0

#10
#1
#40
func _ready():
	# Get the Sprite and Timer nodes
	sprite_node = get_node("Sprite2D")
	timer_node = get_node("Timer")
	loading_bar = get_node("SlowBar")
	timer_node_2= get_node("Timer2")
	add_to_group("Plants")
	
	timer_node.connect("timeout", Callable(self, "_on_timer_timeout"))
	timer_node_2.connect("timeout", Callable(self, "_on_timer_2_timeout"))
	
	timer_node.start()
	timer_node_2.start()
	
	
# Cycle through the spritesheet stopping at the last frame
func _on_timer_timeout():
	if sprite_node.frame < sprite_node.hframes - 1:
		sprite_node.frame = sprite_node.frame + 1

		# Reset current progress to prevent a jump in the loading bar

# Destroy the object when the last sprite frame is rendered and the object is pressed,
func _on_button_pressed():
	if sprite_node.frame == sprite_node.hframes - 1:
		if money_manager.get_locked()==0: 
			queue_free()
			money_manager.add_coins(15)


func _on_timer_2_timeout():	# Update the loading bar value
	loading_bar.value = current_progress
	current_progress+=1.3

# Attack the plant and destroy if it has no more health
var health = 5
func attacked(damage):
	health -= damage
	if(health <= 0):
		queue_free()
