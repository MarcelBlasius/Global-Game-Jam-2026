class_name HealthBar
extends MarginContainer

@export var life_scene: PackedScene

@onready var life_container: HBoxContainer = $LifeContainer

var lives: Array[Life]

func _ready() -> void:
	for child in life_container.get_children():
		child.free()

func add_lives(count_lives: int) -> void:
	for i in count_lives:
		var new_life = life_scene.instantiate()
		life_container.add_child(new_life)
		lives.push_back(new_life)

func remove_lives(count_lives: int) -> void:
	var lives_to_remove_count = min(count_lives, lives.size())
	
	for i in lives_to_remove_count:
		var life = lives.pop_back()
		
		if life:
			life.break_apart()
