extends Control

@export var scene_to_load_on_restart: PackedScene
@export var scene_to_load_on_exit: PackedScene

@onready var window: MarginContainer = $Window

func open() -> void:
	window.show()

func close() -> void:
	window.hide()

func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("open_menu") && !window.visible):
		open()
	elif (event.is_action_pressed("close_menu") && window.visible):
		close()

func _on_button_continue_pressed() -> void:
	close()

func _on_button_restart_pressed() -> void:
	get_tree().change_scene_to_packed(scene_to_load_on_restart)

func _on_button_settings_pressed() -> void:
	pass # Replace with function body.

func _on_button_exit_pressed() -> void:
	get_tree().change_scene_to_packed(scene_to_load_on_exit)
