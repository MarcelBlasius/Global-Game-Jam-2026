extends SubViewport

var tex : ViewportTexture
var image : Image
var last_frame_id : int
#@onready var alphaMat := $MeshInstance2D.material as ShaderMaterial
func _ready() -> void:
	tex = self.get_texture()

func update_texture():
	await RenderingServer.frame_post_draw
	image = tex.get_image()
		
func get_world(inputCoord: Vector2) -> int:
	var frame_id := Engine.get_process_frames()
	if frame_id != last_frame_id:
		update_texture()

	if (image == null):
		return -1
	last_frame_id = frame_id
	
	var width = image.get_width()
	var height = image.get_height()
	inputCoord = inputCoord.clamp(Vector2.ZERO, Vector2(width - 1, height - 1))
	var col = image.get_pixel(int(inputCoord.x), int(inputCoord.y))
	
	if col.r < 0.5:
		return 0
	return 1
