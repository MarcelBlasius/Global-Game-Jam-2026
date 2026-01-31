extends SubViewport

var tex : ViewportTexture

#@onready var alphaMat := $MeshInstance2D.material as ShaderMaterial
func _ready() -> void:
	tex = self.get_texture()

func get_world(inputCoord: Vector2) -> int:
	var width = tex.get_width()
	var height = tex.get_height()
	inputCoord = inputCoord.clamp(Vector2.ZERO, Vector2(width - 1, height - 1))
	var col = tex.get_image().get_pixel(int(inputCoord.x), int(inputCoord.y))
	
	if col.r < 0.5:
		return 0
	return 1
