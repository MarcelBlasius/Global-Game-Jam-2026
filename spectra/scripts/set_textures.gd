extends Node2D


@onready var vp_a := $Subview1
@onready var vp_b := $Subview2
#@onready var vp_alpha := $AlphaTexture
@onready var vp_alpha := $AlphaContainer/AlphaView
@onready var mat := $Combiner.material as ShaderMaterial

func _ready():
	mat.set_shader_parameter("tex_left", vp_a.get_texture())
	mat.set_shader_parameter("tex_right", vp_b.get_texture())
	mat.set_shader_parameter("tex_alpha", vp_alpha.get_texture())
	
	move_backgrounds()


func move_backgrounds():
	var background1 = $Background/BackgroundWorld1
	var old_global1 := background1.global_transform as Transform2D

	background1.get_parent().remove_child(background1)
	$Subview1.add_child(background1)
	background1.global_transform = old_global1
	
	var background2 = $Background/BackgroundWorld2
	var old_global2 := background2.global_transform as Transform2D

	background2.get_parent().remove_child(background2)
	$Subview2.add_child(background2)
	background2.global_transform = old_global2
	
	
#func _process(_delta: float):
	#print_debug($AlphaContainer/AlphaView.get_world(get_viewport().get_mouse_position()))
	#if (vp_alpha):
		#await RenderingServer.frame_post_draw
		#mat.set_shader_parameter("tex_alpha", vp_alpha.get_texture())

## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
