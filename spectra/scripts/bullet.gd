extends Area2D

@export var speed: float = 600.0
@export var damage: int = 1
@export var hit_group : String

const explosion = preload("res://scenes/explosion.tscn")

var direction: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	position += direction * speed * delta
	
func destroy(body: Node2D):
	
	if body.is_in_group("environment"):
		var splat : GPUParticles2D = explosion.instantiate()

		var bounce_direction = -direction.normalized()
		splat.global_position = self.global_position
		splat.look_at(splat.global_position + bounce_direction)#
		splat.emitting = true
		get_tree().current_scene.add_child(splat)
		
	queue_free()
	
func _on_body_entered(body: Node2D):
	
	if !body.is_in_group(hit_group) && !body.is_in_group("environment"):
		return
		
	if body.has_method("take_damage"):
		body.take_damage(damage)
	
	destroy(body)
