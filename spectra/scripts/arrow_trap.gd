extends StaticBody2D

const bullet_scene = preload("res://scenes/bullet.tscn")

@export var fire_rate: float = 0.5 # seconds
@onready var shoot_timer = $ShootTimer
@onready var sprite = $Sprite2D



func _physics_process(_delta: float):	
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
	# initial delay
	shoot_timer.start(randf_range(2.0, 5.0))
