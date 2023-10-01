extends StaticBody2D

@onready
var money_manager = get_node("/root/MoneyManager")


var rng = RandomNumberGenerator.new()
@onready
var timer = get_node("Timer")

# Properties
var damage = 1
var health = ceil(rng.randf_range(3, 5))
var coins_dropped = ceil(rng.randf_range(2, 5))
var speed = 0.2

var targeted_plant = pick_plant_to_attack()


signal attack_plant(damage, targeted_plant)
func _physics_process(delta):
	# Checks if the player already harvested the plant that is being targeted by the zombie
	if(targeted_plant == null):
		targeted_plant = pick_plant_to_attack()
	else:
		var targeted_plant_position = targeted_plant.get_global_position() 
		var mob_position = self.get_global_position()
		var direction = (targeted_plant_position - mob_position).normalized()
		move_and_collide(direction * speed)
		if(mob_position.distance_to(targeted_plant_position) <0.5):

			if (timer.is_stopped()):
				timer.start()
				print("started timer")
	
# Picks a plant at random to attack from the list of plants inside the Plants group
func pick_plant_to_attack():
	var tree = get_tree()
	if tree and tree.has_group("Plants"):
		var plant_nodes = get_tree().get_nodes_in_group("Plants")
		if (plant_nodes.size() != 0):
			var plant_index = rng.randf_range(0, plant_nodes.size())
			return plant_nodes[plant_index]
	return null



# TODO: WHEN THE TIME COMES
# ADD THE GLOBAL VARIABLE THAT IS PLAYER 
# DAMAGE INSTEAD OF TAKING AWAY ONE HEALTH AT A PRESS
func _on_button_pressed():
	health -= 1
	if(health<=0):
		money_manager.add_coins(coins_dropped)
		queue_free()
	

func _on_timer_timeout():
	if targeted_plant != null:
		targeted_plant.attacked(damage)
	else: timer.stop()
