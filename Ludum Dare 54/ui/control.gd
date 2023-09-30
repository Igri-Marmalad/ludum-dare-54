extends Control

var coin_counter_label

@onready
var money_manager = get_node("/root/MoneyManager")
# Called when the node enters the scene tree for the first time.
func _ready():
	money_manager.connect("update_coin_ui_value", Callable(self, "_on_update_coin_ui_value"))
	
	coin_counter_label = get_node("coin_counter")
	coin_counter_label.text = "Coins: " + str(money_manager.get_coins())

func _on_update_coin_ui_value(coins):
	coin_counter_label.text = "Coins: " + str(coins)


