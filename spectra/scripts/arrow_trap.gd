extends CharacterBody2D

const bullet_scene = preload("res://scenes/bullet.tscn")

@export var movement_speed: float = 50
@export var fire_rate: float = 0.5 # seconds
@onready var shoot_timer = $ShootTimer
@onready var rotaiton_cooldown = $RotationCooldown
@onready var sprite = $Sprite2D

var direction: Vector2 

var view1 : Node;
var view2 : Node;
var spriteParent1 : Node;
var spriteParent2 : Node;
var sprite1 : Sprite2D
var sprite2 : Sprite2D

func _ready() -> void:
	view1 = get_node("/root/main_scene/Subview1")
	view2 = get_node("/root/main_scene/Subview2")
	spriteParent1 = $World1Beetle
	spriteParent2 = $World2Beetle
	sprite1 = $World1Beetle/GoldBeetle
	sprite2 = $World2Beetle/DarkBeetle
	sprite1.z_index = 1000
	sprite2.z_index = 1000
	
	var old_global1 := spriteParent1.global_transform as Transform2D

	spriteParent1.get_parent().remove_child(spriteParent1)
	view1.add_child(spriteParent1)
	spriteParent1.global_transform = old_global1
	
	var old_global2 := spriteParent2.global_transform as Transform2D

	spriteParent2.get_parent().remove_child(spriteParent2)
	view2.add_child(spriteParent2)
	spriteParent2.global_transform = old_global2

func _process(delta: float) -> void:
	spriteParent1.global_transform = global_transform
	spriteParent2.global_transform = global_transform

func cooldown_collider():
	var own_collider = $CollisionPolygon2D
	own_collider.disabled = true
	await get_tree().create_timer(1.5).timeout
	own_collider.disabled = false
	
func move(_delta):
	var collided = move_and_slide()
		
	if collided && rotaiton_cooldown.is_stopped():
		var collision = get_last_slide_collision()
		var collider = collision.get_collider()
		
		if !collider.is_in_group("environment"):
			add_collision_exception_with(collider)
			move_and_collide(velocity * _delta)
			return
		
		if collider.is_in_group("environment"):
			var normal = collision.get_normal()
			global_position += normal * 2.0
			direction = direction.orthogonal()
			rotaiton_cooldown.start(3)
			cooldown_collider()
		
			self.rotate(-deg_to_rad(90))
		
	velocity = direction * movement_speed

func _physics_process(_delta: float):	
	move(_delta)
	
	if !shoot_timer.is_stopped(): return
		
	var size = sprite1.get_rect().size * sprite1.scale
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
