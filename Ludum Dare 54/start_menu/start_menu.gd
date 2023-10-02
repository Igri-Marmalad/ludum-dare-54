extends Node2D

signal start_game()

func _on_start_game_button_pressed() -> void:
	get_tree().change_scene_to_file("res://level/main_level.tscn")
	
func _on_quit_button_pressed() -> void:
	get_tree().quit()
