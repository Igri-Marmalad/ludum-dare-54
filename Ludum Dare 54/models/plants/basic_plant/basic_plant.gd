extends Node2D

# Reference to the Sprite and Timer nodes
var sprite_node
var timer_node

var health = 5


@onready
var money_manager = get_node("/root/MoneyManager")


func _ready():
	# Get the Sprite and Timer nodes
	sprite_node = get_node("Sprite2D")
	timer_node = get_node("Timer")
	add_to_group("Plants")

		
# Cycle through the spritesheet stopping at the last frame
func _on_timer_timeout():
	if(sprite_node.frame < sprite_node.hframes - 1):
		sprite_node.frame = (sprite_node.frame + 1)


# Destroy the object when the last sprite frame is rendered and the object is pressed, 
func _on_button_pressed():
	if(sprite_node.frame == sprite_node.hframes - 1):
		queue_free()
		money_manager.add_coins(5)

# Attack the plant and destroy if it has no more health
func attacked(damage):
	health -= damage
	if(health <= 0):
		queue_free()
