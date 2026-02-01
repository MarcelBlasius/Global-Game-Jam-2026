extends MeshInstance2D

@export var noise_tex : NoiseTexture2D

@export var noise : FastNoiseLite
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#noise = noise_tex.noise
	#texture = noise_tex

	#var noise := mat. .noise as FastNoiseLite
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#noise.offset += Vector3(0, 0, 20)
	#noise_tex.reset_state()
	
	#noise_tex.emit_changed()
	#noise.emit_changed()
	#await texture.changed
	#var offset: Vector3 = mat.get_shader_parameter("noise_offset")
	#offset += Vector3(0.1, 0.05) * delta
	#mat.set_shader_parameter("noise_offset", offset)
	
	pass
