extends CharacterBody2D

@export var health: int = 3
@export var speed: int = 500
@export var player: CharacterBody2D
@export var bump_force: float = 400.0

@onready var sprite: Sprite2D = $Sprite2D
var knockback_velocity: Vector2 = Vector2.ZERO


func _physics_process(_delta):
	if !player: return
	
	var direction = (player.global_position - global_position).normalized()
	velocity = (direction * speed) + knockback_velocity
	knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, 1500 * _delta)
	look_at(player.global_position)
	move_and_slide()
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var body = collision.get_collider()
		
		if body == player:	
			self.apply_knockback(body.global_position, bump_force * 0.8)
			
			if body.has_method("apply_knockback"):
				body.apply_knockback(global_position, bump_force)
			
			if body.has_method("take_damage"):
				body.take_damage(1)

func flash_hit():
	sprite.material.set_shader_parameter("active", true)
	await get_tree().create_timer(0.1).timeout
	sprite.material.set_shader_parameter("active", false)
	
func take_damage(amount: int):
	health -= amount
	flash_hit()
	if health <= 0:
		die()

func die():
	queue_free()
	
func apply_knockback(source_position: Vector2, force: float):
	var push_dir = (global_position - source_position).normalized()
	knockback_velocity = push_dir * force
