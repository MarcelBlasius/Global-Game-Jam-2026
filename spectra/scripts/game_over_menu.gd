class_name GameOverMenu
extends Control

@export var game_over_screen_texture: AtlasTexture

@onready var fade: Fade = $Fade

var lock_input := true

func open() -> void:
	fade.fade_in(2.0, game_over_screen_texture)

func _on_fade_fade_in_finished() -> void:
	get_tree().paused = true
	lock_input = false

func _input(event: InputEvent) -> void:
	if lock_input:
		return

	if event.is_pressed() and not event.is_echo():
		_handle_any_button_pressed()

func _handle_any_button_pressed() -> void:
	lock_input = true
	get_tree().paused = false
	fade.fade_out(1.0)
	get_tree().change_scene_to_file("res://scenes/silas/main_menu.tscn")
