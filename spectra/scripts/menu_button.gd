extends TextureButton

@export var shift_amount : float = 4.0

@onready var hover_sound: AudioStreamPlayer = $HoverSound
@onready var press_sound: AudioStreamPlayer = $PressSound

func _on_button_down():
	texture_click_mask = null
	position.x += shift_amount

func _on_button_up():
	position.x -= shift_amount

func _on_pressed() -> void:
	press_sound.play()

func _on_mouse_entered() -> void:
	hover_sound.play()
