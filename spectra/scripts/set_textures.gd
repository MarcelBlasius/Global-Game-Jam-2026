extends Node2D


@onready var vp_a := $Subview1
@onready var vp_b := $Subview2
#@onready var vp_alpha := $AlphaTexture
@onready var vp_alpha := $SubViewportContainer/AlphaView
@onready var mat := $MeshInstance2D.material as ShaderMaterial

func _ready():
	mat.set_shader_parameter("tex_left", vp_a.get_texture())
	mat.set_shader_parameter("tex_right", vp_b.get_texture())
	#mat.set_shader_parameter("tex_alpha", vp_alpha.tex_rd)
	
func _process(_delta: float):
	if (vp_alpha):
		mat.set_shader_parameter("tex_alpha", vp_alpha.get_texture())

## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
