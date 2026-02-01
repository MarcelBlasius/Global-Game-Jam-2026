extends GPUParticles2D



func _ready() -> void:
	var sfx_player = AudioStreamPlayer.new()
	var sfx_resource = load("res://ressources/splash.mp3")
	sfx_player.stream = sfx_resource
	get_node(("/root/main_scene")).add_child(sfx_player)
	
	sfx_player.play()
	await get_tree().create_timer(lifetime).timeout
	queue_free()
