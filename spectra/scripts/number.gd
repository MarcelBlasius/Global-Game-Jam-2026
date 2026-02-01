class_name Number
extends HBoxContainer

@export var textures: Array[AtlasTexture]

func set_number(number: int) -> void:
	for child in get_children():
		child.queue_free()

	var number_string = str(number)

	for digit_char in number_string:
		var digit_int = int(digit_char)
		
		var rect = TextureRect.new()
		rect.texture = textures[digit_int]
		
		rect.stretch_mode = TextureRect.STRETCH_KEEP
		
		add_child(rect)
