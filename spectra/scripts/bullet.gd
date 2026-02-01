extends Area2D

@export var speed: float = 600.0
@export var damage: int = 1
@export var hit_group : String
@export var world = 1


const explosion = preload("res://scenes/explosion.tscn")

var direction: Vector2 = Vector2.ZERO

var view1 : Node;
var view2 : Node;
var spriteParent1 : Node;
var spriteParent2 : Node;
var sprite1 : AnimatedSprite2D
var sprite2 : AnimatedSprite2D

func _ready() -> void:
	view1 = get_node("/root/main_scene/Subview1")
	view2 = get_node("/root/main_scene/Subview2")
	spriteParent1 = $World1Bullet
	spriteParent2 = $World2Bullet
	
	sprite1 = $World1Bullet/SunBullet
	sprite2 = $World2Bullet/DarkBullet
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
	
	spriteParent1.visible = false
	spriteParent2.visible = false

func _process(_delta: float) -> void:
	spriteParent1.global_transform = global_transform
	spriteParent2.global_transform = global_transform
	
func _physics_process(delta: float) -> void:
	position += direction * speed * delta
	spriteParent1.visible = true
	spriteParent2.visible = true
	
func destroy(body: Node2D):
	
	if body.is_in_group("environment"):
		var splat : GPUParticles2D = explosion.instantiate()

		var bounce_direction = -direction.normalized()
		splat.global_position = self.global_position
		splat.look_at(splat.global_position + bounce_direction)#
		splat.emitting = true
		get_tree().current_scene.add_child(splat)
	
	queue_free()
	spriteParent1.queue_free()
	spriteParent2.queue_free()
	

func get_world():
	return world;

func _on_body_entered(body: Node2D):
	
	if !body.is_in_group(hit_group) && !body.is_in_group("environment"):
		return
	
	if !body.has_method("get_world"): return
	
	if body.get_world() != get_world(): return
		
	if body.has_method("take_damage"):
		body.take_damage(damage)
	
	destroy(body)
