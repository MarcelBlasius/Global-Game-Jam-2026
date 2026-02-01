class_name Fade
extends Control

signal fade_in_finished
signal fade_out_finished

@export var start_faded: bool = false
@export var fade_color: Color = Color.BLACK

@onready var color_rect: ColorRect = $ColorRect
@onready var texture_rect: TextureRect = $TextureRect

func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	var initial_alpha = 1.0 if start_faded else 0.0
	color_rect.color = fade_color
	color_rect.color.a = initial_alpha
	texture_rect.modulate.a = initial_alpha
	
	color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	texture_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE

func fade_in(duration: float = 2.0, arg: Variant = null) -> void:
	if arg is Texture2D:
		texture_rect.texture = arg
		texture_rect.modulate.a = 0.0
		color_rect.color.a = 0.0
		_run_tween(texture_rect, "modulate:a", 1.0, duration)
		
	elif arg is Color:
		color_rect.color = arg
		color_rect.color.a = 0.0
		texture_rect.modulate.a = 0.0
		_run_tween(color_rect, "color:a", 1.0, duration)
		
	else:
		color_rect.color = fade_color
		color_rect.color.a = 0.0
		texture_rect.modulate.a = 0.0
		_run_tween(color_rect, "color:a", 1.0, duration)

func fade_out(duration: float = 2.0) -> void:
	_run_tween(color_rect, "color:a", 0.0, duration)
	_run_tween(texture_rect, "modulate:a", 0.0, duration)

func _run_tween(object: Object, property: String, target_alpha: float, duration: float) -> void:
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)
	
	tween.tween_property(object, property, target_alpha, duration)
	
	tween.finished.connect(func():
		if target_alpha == 1.0:
			fade_in_finished.emit()
		else:
			fade_out_finished.emit()
	, CONNECT_ONE_SHOT)
