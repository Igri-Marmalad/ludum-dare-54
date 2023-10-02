extends Control

@onready
var money_manager = get_node("/root/MoneyManager")

func _on_WinGame_button_pressed():
	var win_game_button = get_node("TabContainer/Upgrades/ScrollContainer/VBoxContainer/WinGame/Button") 
	if(money_manager.get_coins() >=  int(win_game_button.get_text())):
		get_tree().quit()


func _on_show_shop_pressed():
	var tab_container = get_node("TabContainer")
	tab_container.visible = !tab_container.visible
