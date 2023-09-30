extends Label

# Exported variable to control coins (visible in the editor).
var coins = 0
var money = 4


var parent_node

# Called when the node enters the scene tree for the first time.
func _ready():
	self.text = "Coins: " + str(coins)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.text = "Coins: " + str(coins)
	for node in get_tree().get_nodes_in_group("Plants"):
		if not node.is_connected("plant_destroyed", Callable(self, "_on_plant_destroyed")):
			node.connect("plant_destroyed", Callable(self, "_on_plant_destroyed"))

func _on_plant_destroyed(money):
	print("DESTROYED")
	coins += money

# Called when the button is pressed.
func _on_button_pressed():
	coins += 5
	self.text = "Coins: " + str(coins)

# Function to check if there are enough coins to make a purchase.
func checkMoney(money):
	return coins >= money

# Function to buy something with the specified amount of money.
func buy():
	if checkMoney(money):
		coins -= money
		self.text = "Coins: " + str(coins)
	else:
		pass
