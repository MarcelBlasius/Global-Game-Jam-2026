extends CharacterBody2D

@export var speed = 400
@export var bullet_scene: PackedScene 
@export var fire_rate: float = 0.5 # seconds
@onready var shoot_timer = $ShootTimer
@onready var sprite = $Sprite2D

func get_movement_direction():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed

func _physics_process(_delta: float):
	get_movement_direction()
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

func spawn_bullet(dir: Vector2, offset: Vector2):
	var bullet = bullet_scene.instantiate()
	get_tree().root.add_child(bullet) 
	bullet.global_position = global_position + offset
	bullet.direction = dir
