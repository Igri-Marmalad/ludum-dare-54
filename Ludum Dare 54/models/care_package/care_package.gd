extends Node2D

@onready
var money_manager = get_node("/root/MoneyManager")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	queue_free()


func _on_button_pressed():
	var rng = RandomNumberGenerator.new()
	money_manager.add_coins(ceil(rng.randf_range(3,8)))
	queue_free()
