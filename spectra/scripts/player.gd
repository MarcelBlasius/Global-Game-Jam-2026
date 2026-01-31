extends CharacterBody2D

@export var health = 3
@export var speed = 400
@export var bullet_scene: PackedScene 
@export var fire_rate: float = 0.5 # seconds
@onready var shoot_timer = $ShootTimer
@onready var invincivility_Timer = $InvincibilityTimer
@onready var sprite = $Node2D/Sprite2D
@onready var node2d = $Node2D
@onready var anim_player : AnimationPlayer = $Node2D/AnimationPlayer
var knockback_velocity: Vector2 = Vector2.ZERO

func get_movement_direction() -> Vector2:
	var input_direction = Input.get_vector("left", "right", "up", "down")
	return input_direction * speed

func _physics_process(_delta: float):
	var move_velocity = get_movement_direction()
	
	velocity = move_velocity + knockback_velocity
	
	knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, 1500 * _delta)
	
	move_and_slide()
	
	if shoot_timer.is_stopped():
		shoot()
		
func shoot():
	var dir = Input.get_vector("shoot left", "shoot right", "shoot up", "shoot down")
	var size = sprite.get_rect().size * sprite.scale
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
	
	node2d.rotation = angle
	sprite.rotation = -angle
	anim_player.play("shoot_animation")


func spawn_bullet(dir: Vector2, offset: Vector2):
	play_shoot_animation(dir)
	var bullet = bullet_scene.instantiate()
	bullet.global_position = global_position + offset
	bullet.direction = dir
	get_tree().root.add_child(bullet) 
	

func flash_hit():
	sprite.material.set_shader_parameter("active", true)
	await get_tree().create_timer(0.1).timeout
	sprite.material.set_shader_parameter("active", false)
	
func take_damage(amount: int):
	if !invincivility_Timer.is_stopped(): return
	
	health -= amount
	flash_hit()
	invincivility_Timer.start()
	
	if health == 0:
		queue_free()
		
func apply_knockback(source_position: Vector2, force: float):
	var push_dir = (global_position - source_position).normalized()
	knockback_velocity = push_dir * force
