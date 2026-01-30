extends Area2D

@export var speed: float = 600.0

var direction: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	position += direction * speed * delta

func _ready() -> void:
	# Auto-delete after 5 seconds
	await get_tree().create_timer(5.0).timeout
	queue_free()
