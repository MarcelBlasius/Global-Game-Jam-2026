extends CharacterBody2D

@export var isEnemyWorld1: bool = true
@export var health: int = 3
@export var speed: int = 500
@export var player: CharacterBody2D
@export var bump_force: float = 400.0
@export var world = 1 # world of entity

#@onready var sprite: Sprite2D = $Sprite2D
var knockback_velocity: Vector2 = Vector2.ZERO

var view1 : Node;
var view2 : Node;
var spriteParent1 : Node;
var spriteParent2 : Node;
var sprite1 : Sprite2D
var sprite2 : Sprite2D

func _ready() -> void:
	view1 = get_node("/root/main_scene/Subview1")
	view2 = get_node("/root/main_scene/Subview2")
	spriteParent1 = $World1
	spriteParent2 = $World2
	sprite1 = $World1/Sprite2D
	sprite2 = $World2/Sprite2D
	sprite1.z_index = 10
	sprite2.z_index = 10
	player = get_node("/root/main_scene/player")
	
	var old_global1 := spriteParent1.global_transform as Transform2D

	spriteParent1.get_parent().remove_child(spriteParent1)
	view1.add_child(spriteParent1)
	spriteParent1.global_transform = old_global1
	
	var old_global2 := spriteParent2.global_transform as Transform2D

	spriteParent2.get_parent().remove_child(spriteParent2)
	view2.add_child(spriteParent2)
	spriteParent2.global_transform = old_global2

func _process(delta: float) -> void:
	#await get_tree().physics_frame
	spriteParent1.global_transform = global_transform
	spriteParent2.global_transform = global_transform

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
	sprite1.material.set_shader_parameter("active", true)
	sprite2.material.set_shader_parameter("active", true)
	await get_tree().create_timer(0.1).timeout
	sprite1.material.set_shader_parameter("active", false)
	sprite2.material.set_shader_parameter("active", false)
	
func take_damage(amount: int):
	health -= amount
	flash_hit()
	if health <= 0:
		die()

func get_world():
	return world

func die():
	get_node("/root/main_scene").remove_enemy(self)
	queue_free()
	spriteParent1.queue_free()
	spriteParent2.queue_free()
	
func apply_knockback(source_position: Vector2, force: float):
	var push_dir = (global_position - source_position).normalized()
	knockback_velocity = push_dir * force
