class_name SettingsMenu
extends Control

@onready var volume_slider: HSlider = $Window/MarginContainer/VBoxContainer/HBoxContainer/VolumeSlider
@onready var window: MarginContainer = $Window

func _ready() -> void:
	#if (volume_slider != null):
		#volume_slider.value = Settings.volume
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("close_menu") && visible:
		close()
		get_viewport().set_input_as_handled()

func open() -> void:
	show()

func close() -> void:
	hide()

func _on_close_button_pressed() -> void:
	close()

func _on_volume_slider_value_changed(value: float) -> void:
	Settings.volume = value
