extends Control

@onready var window: MarginContainer = $Window
@onready var settings_menu: SettingsMenu = $SettingsMenu

func _ready() -> void:
	settings_menu.close()
	close()

func open() -> void:
	window.show()
	get_tree().paused = true

func close() -> void:
	window.hide()
	get_tree().paused = false

func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("open_menu") && !window.visible):
		open()
	elif (event.is_action_pressed("close_menu") && window.visible):
		close()

func _on_button_continue_pressed() -> void:
	close()

func _on_button_restart_pressed() -> void:
	close()
	get_tree().change_scene_to_file("res://scenes/main_scene.tscn")

func _on_button_settings_pressed() -> void:
	settings_menu.open()

func _on_button_exit_pressed() -> void:
	close()
	get_tree().change_scene_to_file("res://scenes/silas/main_menu.tscn")
