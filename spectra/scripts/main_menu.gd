extends Control

@onready var settings_menu: SettingsMenu = $SettingsMenu

func _ready() -> void:
	settings_menu.close()

func _on_button_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_scene.tscn")

func _on_button_settings_pressed() -> void:
	settings_menu.open()

func _on_button_quit_pressed() -> void:
	get_tree().quit()
