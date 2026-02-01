extends Node2D

@onready var vp_a := $Subview1
@onready var vp_b := $Subview2
#@onready var vp_alpha := $AlphaTexture
@onready var vp_alpha := $AlphaContainer/AlphaView
@onready var mat := $Combiner.material as ShaderMaterial
@export var spawn_enemies = true

const enemy_standard_1 = preload("res://scenes/enemies/enemy_two_worlds.tscn") 

var current_world : int = 1
@onready var alpha = $AlphaContainer/AlphaView/WorldAlpha/MeshInstance2D as Alpha
@onready var player = $player
@onready var background: Background = $Background

func _ready():
	mat.set_shader_parameter("tex_left", vp_a.get_texture())
	mat.set_shader_parameter("tex_right", vp_b.get_texture())
	mat.set_shader_parameter("tex_alpha", vp_alpha.get_texture())
	
	move_backgrounds()
	level_one()


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

func get_random_pos(offset: int = 40) -> Vector2:
	var viewport := get_viewport()
	var size := viewport.get_visible_rect().size

	var pos = Vector2(
		randf_range(offset, size.x - offset),
		randf_range(offset, size.y - offset))
	return pos
	

func spawn_enemy(enemyScene : PackedScene, time: float = 0):
	await get_tree().create_timer(time).timeout
	if !spawn_enemies:
		return
	var enemy = enemyScene.instantiate()
	
	var pos := get_random_pos()
	
	while (pos.distance_to(player.global_position) < 200):
		pos = get_random_pos()
	
	enemy.global_position = pos
	#enemy.direction = dir
	#enemy.hit_group = "enemies"
	add_child.call_deferred(enemy) 
	enemies.append(enemy)

func level_one():
	alpha.set_world(current_world)
	var time = 2.0
	for i in range(3):
		spawn_enemy(enemy_standard_1, time)
		time += 2
	
	var pos = get_random_pos(150)
	spawn_portal_routine(pos, 8)
	
@export var spawn_curve: Curve
@export var finish_curve: Curve

func spawn_portal_routine(pos : Vector2, time: float = 0):
	await get_tree().create_timer(time).timeout
	#var timer = Timer.new()#	
	
	var maskPos := Alpha.MaskPos.new()
	maskPos.pos = pos
	maskPos.radius = 0
	maskPos.worldBit = 0
	alpha.posList.append(maskPos)
	animate_portal_spawn_routine(maskPos, 50, spawn_curve)
	
func spawn_end_portal_routine(pos : Vector2, time: float = 0):
	await get_tree().create_timer(time).timeout
	#var timer = Timer.new()#	
	
	var maskPos := Alpha.MaskPos.new()
	maskPos.pos = pos
	maskPos.radius = 0
	maskPos.worldBit = 1
	alpha.posList.append(maskPos)
	animate_portal_spawn_routine(maskPos, 640, finish_curve)



func animate_portal_spawn_routine(mask : Alpha.MaskPos, radius: float, curve: Curve):
	var current_mills = Time.get_ticks_msec()
	var animLength = 7.0 * 1000
	while (Time.get_ticks_msec() - current_mills < animLength):
		var t = (Time.get_ticks_msec() - current_mills) / (animLength)
		var y = curve.sample(t)
		mask.radius = radius * y
		await get_tree().process_frame
	mask.radius = radius

var portal_lifetime : float = 4

func animate_portal_despawn_routine(mask : Alpha.MaskPos, radius: float, curve: Curve):
	await get_tree().create_timer(portal_lifetime).timeout
	var current_mills = Time.get_ticks_msec()
	var animLength = 7.0 * 1000
	while (Time.get_ticks_msec() - current_mills < animLength):
		var t = (Time.get_ticks_msec() - current_mills) / (animLength)
		var y = curve.sample(1 - t)
		mask.radius = radius * y
		await get_tree().process_frame
	mask.radius = 0
	alpha.posList.erase(mask)
	current_maskPos_to_delete = null

var current_maskPos_to_delete : Alpha.MaskPos

func check_portal_despawn():
	if (current_maskPos_to_delete != null):
		return
	if (alpha.posList.size() > 2):
		current_maskPos_to_delete = alpha.posList.get(0)
		animate_portal_despawn_routine(current_maskPos_to_delete, 50, finish_curve)
	
func remove_enemy(enemy: Node):
	enemies.erase(enemy)
	if (enemies.size() == 0):
		
		end_round()
		spawn_end_portal_routine(enemy.global_position)
		return
	spawn_portal_routine(enemy.global_position)
		
		
func _process(_delta: float):
	check_portal_despawn()
	#print_debug(await $AlphaContainer/AlphaView.get_world(get_viewport().get_mouse_position()))
	pass
	#if (vp_alpha):
		#await RenderingServer.frame_post_draw
		#mat.set_shader_parameter("tex_alpha", vp_alpha.get_texture())

func end_round():
	background.fade_out_tutorial()
	print("oioioioioi")
	pass
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
