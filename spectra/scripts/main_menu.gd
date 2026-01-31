extends Control

@export var scene_to_load: PackedScene

func _on_button_start_pressed() -> void:
	get_tree().change_scene_to_packed(scene_to_load)


func _on_button_settings_pressed() -> void:
	pass


func _on_button_quit_pressed() -> void:
	get_tree().quit()
