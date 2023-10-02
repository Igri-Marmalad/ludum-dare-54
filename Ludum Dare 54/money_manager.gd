extends Node

# Exported variable to control coins (visible in the editor).
var _coins = 0

var coin_counter_label

var _locked = 1

signal update_coin_ui_value(coins)

func _ready():
	add_coins(5)

func get_coins():
	return _coins

# Checks if you have enough money to buy ...
func buy(price):
	if (_coins >= price):
		_coins -= price
		update_coin_ui_value.emit(_coins)
		return true
	else:
		return false

func add_coins(amount):
	_coins += amount
	update_coin_ui_value.emit(_coins)
	
func lock():
	_locked = 1

func unlock():
	_locked = 0

func get_locked():
	return _locked
	
	

