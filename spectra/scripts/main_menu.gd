extends Control

func _on_button_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_scene.tscn")

func _on_button_settings_pressed() -> void:
	pass

func _on_button_quit_pressed() -> void:
	get_tree().quit()
