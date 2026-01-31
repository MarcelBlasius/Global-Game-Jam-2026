class_name Background
extends Node2D

@export var tutorial_fade_out_duration := 1

@onready var tutorial_1: Sprite2D = $BackgroundWorld1/Tutorial
@onready var tutorial_2: Sprite2D = $BackgroundWorld2/Tutorial

func fade_out_tutorial() -> void:
	var tween = create_tween()
	
	tween.set_parallel(true)
	
	tween.tween_property(tutorial_1, "modulate:a", 0.0, tutorial_fade_out_duration)
	tween.tween_property(tutorial_2, "modulate:a", 0.0, tutorial_fade_out_duration)
	
	tween.chain().tween_callback(tutorial_1.hide)
	tween.chain().tween_callback(tutorial_2.hide)
