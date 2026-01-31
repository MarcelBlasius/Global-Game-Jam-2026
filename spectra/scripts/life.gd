class_name Life
extends HBoxContainer

@onready var left: TextureRect = $Left
@onready var right: TextureRect = $Right

func break_apart() -> void:
	var tween = create_tween().set_parallel(true)
	
	tween.tween_property(left, "position:x", left.position.x - 10, 0.4).set_trans(Tween.TRANS_EXPO)
	tween.tween_property(left, "rotation_degrees", -15, 0.4)
	tween.tween_property(left, "modulate:a", 0.0, 0.4)
	
	tween.tween_property(right, "position:x", right.position.x + 10, 0.4).set_trans(Tween.TRANS_EXPO)
	tween.tween_property(right, "rotation_degrees", 15, 0.4)
	tween.tween_property(right, "modulate:a", 0.0, 0.4)
	
	tween.set_parallel(false)
	tween.tween_callback(queue_free)
