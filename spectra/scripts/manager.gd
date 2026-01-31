extends Node2D


@onready var vp_a := $Subview1
@onready var vp_b := $Subview2
#@onready var vp_alpha := $AlphaTexture
@onready var vp_alpha := $AlphaContainer/AlphaView
@onready var mat := $Combiner.material as ShaderMaterial
@export var spawn_enemies = true

@export var enemy_scene : PackedScene 

func _ready():
	mat.set_shader_parameter("tex_left", vp_a.get_texture())
	mat.set_shader_parameter("tex_right", vp_b.get_texture())
	mat.set_shader_parameter("tex_alpha", vp_alpha.get_texture())
	
	move_backgrounds()
	
	if spawn_enemies:
		for i in range(3):
			spawn_enemy()


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

var enemies : Array[Node]
func spawn_enemy():
	var enemy = enemy_scene.instantiate()
	
	var viewport := get_viewport()
	var size := viewport.get_visible_rect().size

	var pos := Vector2(
	randf_range(0, size.x),
	randf_range(0, size.y)
)
	enemy.global_position = pos
	#enemy.direction = dir
	#enemy.hit_group = "enemies"
	get_tree().root.add_child.call_deferred(enemy) 
	enemies.append(enemy)
	
#func _process(_delta: float):
	#print_debug($AlphaContainer/AlphaView.get_world(get_viewport().get_mouse_position()))
	#if (vp_alpha):
		#await RenderingServer.frame_post_draw
		#mat.set_shader_parameter("tex_alpha", vp_alpha.get_texture())

## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
