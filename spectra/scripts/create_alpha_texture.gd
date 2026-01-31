extends Node2D

@export
var tex_rd: Texture2DRD
const WIDTH := 640
const HEIGHT := 360
var rd: RenderingDevice
var tex_rid: RID

var shader: RID
var pipeline: RID
var uniform_set: RID

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#rd = RenderingServer.create_local_rendering_device()
	#RenderingServer.call_on_render_thread(create_texture)
	#RenderingServer.call_on_render_thread(create_pipeline)
	create_texture()
	create_pipeline()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#if (tex_rd != null):
		#self.texture = tex_rd
	dispatch()
	#RenderingServer.call_on_render_thread(dispatch)
	pass
	
func create_texture():
	rd = RenderingServer.get_rendering_device()
	var format := RDTextureFormat.new()
	format.texture_type = RenderingDevice.TEXTURE_TYPE_2D
	format.width = WIDTH
	format.height = HEIGHT
	format.format = RenderingDevice.DATA_FORMAT_R32_SFLOAT
	format.texture_type = RenderingDevice.TEXTURE_TYPE_2D
	format.depth = 1
	#format.usage_bits = (
		#RenderingDevice.TEXTURE_USAGE_STORAGE_BIT | # compute write
		#RenderingDevice.TEXTURE_USAGE_SAMPLING_BIT  # shader read
	#)
	format.usage_bits = RenderingDevice.TEXTURE_USAGE_SAMPLING_BIT + RenderingDevice.TEXTURE_USAGE_COLOR_ATTACHMENT_BIT + RenderingDevice.TEXTURE_USAGE_STORAGE_BIT + RenderingDevice.TEXTURE_USAGE_CAN_UPDATE_BIT + RenderingDevice.TEXTURE_USAGE_CAN_COPY_TO_BIT

	var view := RDTextureView.new()

	tex_rid = rd.texture_create(format, view)
	tex_rd = Texture2DRD.new()
	tex_rd.texture_rd_rid = tex_rid


func create_pipeline():
	var shader_file := load("res://shaders/compute/alpha_mask.glsl")
	shader = rd.shader_create_from_spirv(shader_file.get_spirv())

	pipeline = rd.compute_pipeline_create(shader)

	var uniform := RDUniform.new()
	uniform.uniform_type = RenderingDevice.UNIFORM_TYPE_IMAGE
	uniform.binding = 0
	uniform.add_id(tex_rid)

	uniform_set = rd.uniform_set_create([uniform], shader, 0)
	
func dispatch():
	var cmd := rd.compute_list_begin()

	rd.compute_list_bind_compute_pipeline(cmd, pipeline)
	rd.compute_list_bind_uniform_set(cmd, uniform_set, 0)

	var push_constant : PackedFloat32Array = PackedFloat32Array()
	push_constant.push_back(123)
	push_constant.push_back(123)
	push_constant.push_back(50)
	push_constant.push_back(0)

	rd.compute_list_set_push_constant(cmd,push_constant.to_byte_array(), push_constant.size() * 4)

	var x_groups = (WIDTH - 1) / 8 + 1
	var y_groups = (HEIGHT - 1) / 8 + 1
	
	rd.compute_list_dispatch(cmd, x_groups, y_groups, 1)
	#int(ceil(WIDTH / 8.0)),
 	#int(ceil(HEIGHT / 8.0)),
	rd.compute_list_end()
	#rd.barrier(RenderingDevice.BARRIER_MASK_COMPUTE)
	#rd.submit()
