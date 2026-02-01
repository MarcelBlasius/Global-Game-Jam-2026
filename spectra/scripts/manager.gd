extends Node2D

@onready var vp_a := $Subview1
@onready var vp_b := $Subview2
#@onready var vp_alpha := $AlphaTexture
@onready var vp_alpha := $AlphaContainer/AlphaView
@onready var mat := $Combiner.material as ShaderMaterial
@export var spawn_enemies = true

const enemy_mask_sun = preload("res://scenes/enemies/SunMask.tscn") 
const enemy_mask_dark = preload("res://scenes/enemies/DarkMask.tscn") 
const enemy_whisp_sun = preload("res://scenes/enemies/SunWhisp.tscn")
const enemy_whisp_dark = preload("res://scenes/enemies/DarkWhisp.tscn")

var current_world : int = 1
@onready var alpha = $AlphaContainer/AlphaView/WorldAlpha/MeshInstance2D as Alpha
@onready var player = $player as CustomPlayer
@onready var background: Background = $Background
@onready var fade: Fade = $Fade
@onready var game_over_menu: GameOverMenu = $GameOverMenu

func _ready():
	mat.set_shader_parameter("tex_left", vp_a.get_texture())
	mat.set_shader_parameter("tex_right", vp_b.get_texture())
	mat.set_shader_parameter("tex_alpha", vp_alpha.get_texture())
	
	fade.fade_out()
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

class Enemy_Info:
	var enemy: Node
	var radius: float

var enemies : Array[Enemy_Info]

func get_random_pos(offset: int = 40) -> Vector2:
	var viewport := get_viewport()
	var size := viewport.get_visible_rect().size

	var pos = Vector2(
		randf_range(offset, size.x - offset),
		randf_range(offset, size.y - offset))
	return pos
	
var enemy_counter = 0

func spawn_enemy(enemyScene: PackedScene, death_rad : float, time: float = 0):
	enemy_counter += 1
	var timer = get_tree().create_timer(time)
	await timer.timeout
	
	if !is_inside_tree() or !spawn_enemies:
		return
		
	if !is_instance_valid(player):
		return

	var enemy = enemyScene.instantiate()
	var pos := get_random_pos()
	
	while is_instance_valid(player) and pos.distance_to(player.global_position) < 200:
		pos = get_random_pos()
		
	if !is_instance_valid(player):
		enemy.queue_free()
		return
		
	enemy.global_position = pos
	#enemy.direction = dir
	#enemy.hit_group = "enemies"
	add_child.call_deferred(enemy) 
	var enemy_info := Enemy_Info.new()
	enemy_info.enemy = enemy
	enemy_info.radius = death_rad
	enemies.append(enemy_info)

var randis := [enemy_mask_sun, enemy_mask_dark, enemy_whisp_sun, enemy_whisp_dark] 
var spawnis := [80, 80, 30, 30]
func level_one():
	alpha.set_world(current_world)
	var time = 2.0
	for i in range(3):
		spawn_enemy(enemy_mask_sun, spawnis[0], time)
		time += 2
	
	var pos = get_random_pos(150)
	#spawn_portal_routine(pos, 70,  1)
	
func level_two():
	alpha.set_world(current_world)
	var time = 2.0
	var randamount = randi_range(5, 7)
	
	for i in range(randamount):
		var randi = randi_range(0, randis.size() - 1)
		var randif = randf_range(1.5, 2)
		spawn_enemy(randis[randi], spawnis[randi], time)
		time += randif
	
	var pos = get_random_pos(150)
	#spawn_portal_routine(pos, 70, 8)
	
@export var spawn_curve: Curve
@export var finish_curve: Curve

func spawn_portal_routine(pos : Vector2, radius : float, time: float = 0):
	await get_tree().create_timer(time).timeout
	#var timer = Timer.new()#
		
	var maskPos := Alpha.MaskPos.new()
	maskPos.pos = pos
	maskPos.radius = 0
	maskPos.worldBit = 0
	maskPos.endRadius = radius
	alpha.posList.append(maskPos)
	animate_portal_spawn_routine(maskPos, spawn_curve)
	
func spawn_end_portal_routine(pos : Vector2, time: float = 0):
	var tree = get_tree()
	if (tree == null):
		return
	await tree.create_timer(time).timeout
	#var timer = Timer.new()#	
	
	var sound = randi_range(0, 1)
	if (sound == 0):
		$PortalSpawn1.play()
	else:
		$PortalSpawn2.play()
		
	var maskPos := Alpha.MaskPos.new()
	maskPos.pos = pos
	maskPos.radius = 0
	maskPos.worldBit = 1
	maskPos.endRadius = 640
	alpha.endPortal = maskPos
	var animLength =7.0
	animate_portal_spawn_routine(maskPos, finish_curve, animLength)
	
	if (tree == null):
		return
	await tree.create_timer(animLength).timeout
	current_world = 1 if (current_world == 0) else 0
	alpha.set_world(current_world)
	alpha.endPortal = null
	end_round()
	
	
func animate_portal_spawn_routine(mask : Alpha.MaskPos, curve: Curve, animLength : float = 7.0):
	var current_mills = Time.get_ticks_msec()
	var animLengthMills = animLength * 1000
	while (Time.get_ticks_msec() - current_mills < animLengthMills):
		var t = (Time.get_ticks_msec() - current_mills) / (animLengthMills)
		var y = curve.sample(t)
		mask.radius = mask.endRadius * y
		var tree = get_tree()
		if (tree == null):
			return
		await tree.process_frame
	mask.radius = mask.endRadius

var portal_lifetime : float = 4

func animate_portal_despawn_routine(mask : Alpha.MaskPos, curve: Curve):
	await get_tree().create_timer(portal_lifetime).timeout
	var current_mills = Time.get_ticks_msec()
	var animLength = 7.0 * 1000
	while (Time.get_ticks_msec() - current_mills < animLength):
		var t = (Time.get_ticks_msec() - current_mills) / (animLength)
		var y = curve.sample(1 - t)
		mask.radius = mask.endRadius * y
		var tree = get_tree()
		if (tree == null):
			return
		await tree.process_frame
	mask.radius = 0
	alpha.posList.erase(mask)
	current_masks_to_delete.erase(mask)

var current_masks_to_delete : Array[Alpha.MaskPos]
#var end_Mask_not_to_delete : Alpha.MaskPos

func check_portal_despawn():
	if (alpha.posList.size() - current_masks_to_delete.size()  > 1):
		var curr_mask : Alpha.MaskPos 
		for posMask in alpha.posList:
			if (current_masks_to_delete.has(posMask)):
				continue
			curr_mask = posMask
			current_masks_to_delete.append(posMask)
			break;
			
		animate_portal_despawn_routine(curr_mask, finish_curve)
	
func find_by_key(search_key: Node) -> Enemy_Info:
	for enemy in enemies:
		if enemy.enemy == search_key:
			return enemy
	return null
	
func remove_enemy(enemy: Node):
	var enemy_info = find_by_key(enemy)
	enemies.erase(enemy_info)
	enemy_counter -= 1
	if (enemy_counter <= 0):
		enemy_counter = 0
		spawn_end_portal_routine(enemy.global_position)
		return
	spawn_portal_routine(enemy.global_position, enemy_info.radius)
		
		
func _process(_delta: float):
	check_portal_despawn()
	#print_debug(await $AlphaContainer/AlphaView.get_world(get_viewport().get_mouse_position()))
	#check_player_spell()
	pass
	#if (vp_alpha):
		#await RenderingServer.frame_post_draw
		#mat.set_shader_parameter("tex_alpha", vp_alpha.get_texture())

func end_round():
	background.fade_out_tutorial()
	level_two()
	print("oioioioioi")
	pass
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass

func _on_player_player_died() -> void:
	game_over_menu.open()

var player_skill_cd : float = 5
var player_skill_current_cd : float = -100000
func _unhandled_input(input_event: InputEvent) -> void:
	# If tool enabled, we don't want to handle our input in the editor.
	if Engine.is_editor_hint():
		return

	if input_event is InputEventKey and input_event.pressed and not input_event.echo:
		if input_event.keycode == KEY_E:
			if (Time.get_ticks_msec() - player_skill_current_cd >= player_skill_cd * 1000):
				spawn_portal_routine(player.global_position, 50, 0)
				player_skill_current_cd = Time.get_ticks_msec()
			
