extends CharacterBody2D

@export var health = 3
@export var speed = 400
const bullet_scene = preload("res://scenes/player_bullet.tscn")

@export var fire_rate: float = 0.5 # seconds
@onready var shoot_timer = $ShootTimer
@onready var invincivility_Timer = $InvincibilityTimer

@onready var anim_player1 : AnimationPlayer = $World1/AnimationPlayer
@onready var anim_player2 : AnimationPlayer = $World2/AnimationPlayer
@onready var recoil_player1: AnimationPlayer = $World1/RecoilPlayer
@onready var recoil_player2: AnimationPlayer = $World2/RecoilPlayer
var knockback_velocity: Vector2 = Vector2.ZERO

var view1 : Node;
var view2 : Node;
var spriteParent1 : Node;
var spriteParent2 : Node;
var sprite1 : Sprite2D
var sprite2 : Sprite2D
var health_bar : HealthBar

func _ready() -> void:
	view1 = get_node("/root/main_scene/Subview1")
	view2 = get_node("/root/main_scene/Subview2")
	spriteParent1 = $World1
	spriteParent2 = $World2
	sprite1 = $World1/Sprite2D
	sprite2 = $World2/Sprite2D
	sprite1.z_index = 20
	sprite2.z_index = 20
	spriteParent1.z_index = 20
	spriteParent2.z_index = 20
	
	health_bar = get_node("/root/main_scene/HealthBar")
	if (health_bar):
		health_bar.add_lives(health)
	
	var old_global1 := spriteParent1.global_transform as Transform2D

	spriteParent1.get_parent().remove_child(spriteParent1)
	view1.add_child(spriteParent1)
	spriteParent1.global_transform = old_global1
	
	var old_global2 := spriteParent2.global_transform as Transform2D

	spriteParent2.get_parent().remove_child(spriteParent2)
	view2.add_child(spriteParent2)
	spriteParent2.global_transform = old_global2

func _process(_delta: float) -> void:
	spriteParent1.global_transform.origin = global_transform.origin
	spriteParent2.global_transform.origin = global_transform.origin
	#await get_tree().physics_frame
	
	
func get_movement_direction() -> Vector2:
	var input_direction = Input.get_vector("left", "right", "up", "down")
	return input_direction * speed

func _physics_process(_delta: float):
	var move_velocity = get_movement_direction()
	
	velocity = move_velocity + knockback_velocity
	knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, 1500 * _delta)
	
	move_and_slide()
	
	var shoot_dir = Input.get_vector("shoot left", "shoot right", "shoot up", "shoot down")
	
	if shoot_dir.x > 0:
		anim_player1.play("walk_right")
		anim_player2.play("walk_right")
	elif shoot_dir.x < 0:
		anim_player1.play("walk_left")
		anim_player2.play("walk_left")
	
	else:
		if move_velocity.x > 0:
			anim_player1.play("walk_right")
			anim_player2.play("walk_right")
		elif move_velocity.x < 0:
			anim_player1.play("walk_left")
			anim_player2.play("walk_left")
		elif move_velocity == Vector2.ZERO:
			anim_player1.stop() # Or play "idle"
			anim_player2.stop() # Or play "idle"
			
	if shoot_timer.is_stopped() and shoot_dir != Vector2.ZERO:
		shoot(shoot_dir)

func shoot(dir: Vector2):
	var size = sprite1.get_rect().size * sprite1.scale
	var width = size.x
	var height = size.y
	var offset = Vector2.ZERO
	
	if (Input.is_action_pressed("shoot down")):
		offset += Vector2(0, height)
		
	if (Input.is_action_pressed("shoot up")):
		offset += Vector2(0, -height)
		
	if (Input.is_action_pressed("shoot left")):
		offset += Vector2(-width, 0)
	
	if (Input.is_action_pressed("shoot right")):
		offset += Vector2(width, 0)
	
	if dir == Vector2.ZERO:
		return
		
	spawn_bullet(dir, offset)
	shoot_timer.start(fire_rate)

func play_shoot_animation(dir: Vector2):	
	var angle = dir.angle()
	
	spriteParent1.rotation = angle
	sprite1.rotation = -angle
	
	spriteParent2.rotation = angle
	sprite2.rotation = -angle

	recoil_player1.play("shoot_animation")
	recoil_player2.play("shoot_animation")

func spawn_bullet(dir: Vector2, offset: Vector2):
	var bullet = bullet_scene.instantiate()
		
	play_shoot_animation(dir)
	bullet.global_position = global_position + (offset / 2)
	bullet.direction = dir
	bullet.hit_group = "enemies"
	get_tree().current_scene.add_child(bullet) 


func get_world():
	return get_node("/root/main_scene/AlphaContainer/AlphaView").get_world(self.global_position)	

func flash_hit():
	sprite1.material.set_shader_parameter("active", true)
	sprite2.material.set_shader_parameter("active", true)
	await get_tree().create_timer(0.1).timeout
	sprite1.material.set_shader_parameter("active", false)
	sprite2.material.set_shader_parameter("active", false)
	
func take_damage(amount: int):
	if !invincivility_Timer.is_stopped(): return
	
	health -= amount
	
	if (health_bar):
		health_bar.remove_lives(amount)
	
	flash_hit()
	invincivility_Timer.start()
	
	if health == 0:
		queue_free()
		spriteParent1.queue_free()
		spriteParent2.queue_free()
		
func apply_knockback(source_position: Vector2, force: float):
	var push_dir = (global_position - source_position).normalized()
	knockback_velocity = push_dir * force
