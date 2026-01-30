extends CharacterBody2D

@export var health: int = 3

func take_damage(amount: int):
	health -= amount
	print("Enemy hit! Health remaining: ", health)
	
	if health <= 0:
		die()

func die():
	queue_free()
