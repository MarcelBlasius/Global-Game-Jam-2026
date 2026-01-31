extends TextureButton

@export var shift_amount : float = 4.0

func _on_button_down():
	texture_click_mask = null
	position.x += shift_amount

func _on_button_up():
	position.x -= shift_amount
