extends Area2D

@export var speed: float = 600.0
@export var damage: int = 1

var direction: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	position += direction * speed * delta

func _ready() -> void:
	# Auto-delete after 5 seconds
	await get_tree().create_timer(5.0).timeout
	queue_free()

func _on_body_entered(body: Node2D):
	if !body.is_in_group("enemies") && !body.is_in_group("environment"):
		return
		
	if body.has_method("take_damage"):
		body.take_damage(damage)
	
	queue_free()
