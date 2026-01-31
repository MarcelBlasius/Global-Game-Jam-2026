extends CharacterBody2D

const bullet_scene = preload("res://scenes/bullet.tscn")

@export var movement_speed: float = 50
@export var fire_rate: float = 0.5 # seconds
@onready var shoot_timer = $ShootTimer
@onready var rotaiton_cooldown = $RotationCooldown
@onready var sprite = $Sprite2D

var direction: Vector2 
var last_collision : int
var before_last_collision: int

func cooldown_collider():
	var own_collider = $CollisionPolygon2D
	own_collider.disabled = true
	await get_tree().create_timer(1.5).timeout
	own_collider.disabled = false
	
func move():
	var collided = move_and_slide()
	
	if collided && rotaiton_cooldown.is_stopped():
		var collision = get_last_slide_collision()
		var collider = collision.get_collider()
		
		if collider.is_in_group("environment"):
			var normal = collision.get_normal()
			global_position += normal * 2.0
			direction = direction.orthogonal()
			rotaiton_cooldown.start(3)
			cooldown_collider()
		
			self.rotate(-deg_to_rad(90))
		
	velocity = direction * movement_speed
	
func _physics_process(_delta: float):	
	move()
	
	if !shoot_timer.is_stopped(): return
		
	var size = sprite.get_rect().size * sprite.scale
	var offset = transform.y * size.y
	
	spawn_bullet(-transform.y, -offset)
	shoot_timer.start(fire_rate)
	
	
func spawn_bullet(dir: Vector2, offset: Vector2):
	var bullet = bullet_scene.instantiate()
	bullet.global_position = global_position + offset
	bullet.direction = dir
	bullet.hit_group = "player"
	get_tree().root.add_child(bullet) 
	


func _on_ready() -> void:
	direction = transform.x
	shoot_timer.start(randf_range(2.0, 5.0))
