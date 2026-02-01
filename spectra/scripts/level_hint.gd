class_name LevelHint
extends Control

@export var fade_in_time := 0.3
@export var stay_time := 1.5
@export var fade_out_time := 1.0

var level := 0

@onready var number: Number = $MarginContainer/HBoxContainer/Number

func _ready() -> void:
	modulate.a = 0.0
	hide() # Start hidden
	# test
	play_hint()

func play_hint() -> void:
	# 1. Make sure the node is visible and reset alpha
	show() 
	modulate.a = 0.0
	
	level += 1
	number.set_number(level)
	
	# 2. Kill any existing tween to prevent overlapping animations
	var tween = create_tween()
	
	# 3. Quick Fade In
	tween.tween_property(self, "modulate:a", 1.0, fade_in_time).set_trans(Tween.TRANS_SINE)
	
	# 4. Stay duration
	tween.tween_interval(stay_time)
	
	# 5. Slow Fade Out
	tween.tween_property(self, "modulate:a", 0.0, fade_out_time).set_trans(Tween.TRANS_SINE)
	
	# 6. Hide when finished
	tween.finished.connect(func(): hide())
