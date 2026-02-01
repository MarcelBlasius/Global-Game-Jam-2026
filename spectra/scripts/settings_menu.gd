class_name SettingsMenu
extends Control

@onready var volume_slider: HSlider = $Window/MarginContainer/VBoxContainer/HBoxContainer/VolumeSlider
@onready var window: MarginContainer = $Window

func _ready() -> void:
	if (volume_slider != null):
		volume_slider.value = 50
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
	var bus_index = AudioServer.get_bus_index("Master")
	
	if value <= 0:
		AudioServer.set_bus_mute(bus_index, true)
	else:
		AudioServer.set_bus_mute(bus_index, false)
		# formula: (value - 50) * (target_db / 50_units)
		# (100 - 50) * 0.24 = 12 dB
		# (50 - 50) * 0.24 = 0 dB
		# (1 - 50) * 0.24 = -11.76 dB
		
		var db_value = (value - 50) * 0.24
		
		if value < 50:
			db_value = remap(value, 0, 50, -40, 0)
			
		AudioServer.set_bus_volume_db(bus_index, db_value)
