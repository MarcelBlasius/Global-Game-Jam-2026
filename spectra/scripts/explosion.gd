extends GPUParticles2D

func play():
	var sfx_player = AudioStreamPlayer.new()
	var sfx_resource = load("res://ressources/splash.mp3")
	sfx_player.stream = sfx_resource
	get_node(("/root/main_scene")).add_child(sfx_player)#
	sfx_player.play();
	await get_tree().create_timer(5).timeout
	get_node(("/root/main_scene")).remove_child(sfx_player)

func _ready() -> void:	
	play()
	await get_tree().create_timer(lifetime).timeout
	queue_free()
