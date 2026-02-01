class_name Alpha
extends MeshInstance2D

#@export var noise_tex1 : NoiseTexture2D

class MaskPos:
	var pos: Vector2
	var radius: float
	var worldBit : float
	var endRadius : float

var mat : ShaderMaterial
var posList : Array[MaskPos]
var endPortal : MaskPos
const arrayMaxLength := 20
const arrayElementSize := 4
var invert_world := false
var mouse_pos: Vector2
var mouse_pressed: bool = false
var mouse_scroll: float = 1
var invert_world_debug: bool = false

@onready var vp_noise := $SubViewport

func set_world(index: int):
	if (index == 0):
		invert_world = true
	elif (index == 1):
		invert_world = false

func setPosAndRad():
	var posVals := []
	posVals.resize(arrayMaxLength * arrayElementSize)
	
	if (endPortal == null):
		posVals[0] = -1000
		posVals[1] = -1000
		posVals[2] = -1000
		posVals[3] = -1000
	else:
		posVals[0] = endPortal.pos.x
		posVals[1] = endPortal.pos.y
		posVals[2] = endPortal.radius	
		posVals[3] = endPortal.worldBit
	
	for i in range(1, arrayMaxLength):
		if (i - 1 < posList.size()):
			posVals[i * arrayElementSize] = posList[i - 1].pos.x
			posVals[i * arrayElementSize + 1] = posList[i - 1].pos.y
			posVals[i * arrayElementSize + 2] = posList[i - 1].radius
			posVals[i * arrayElementSize + 3] = posList[i - 1].worldBit
		else:
			posVals[i * arrayElementSize] = -1000
			posVals[i * arrayElementSize + 1] = -1000
			posVals[i * arrayElementSize + 2] = -1000
			posVals[i * arrayElementSize + 3] = -1000
		
	material.set_shader_parameter("posValues", posVals)
	material.set_shader_parameter("value_count", arrayMaxLength)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	material.set_shader_parameter("tex_noise", vp_noise.get_texture())
	#posList.resize(arrayMaxLength)
	#print(posList.size())
	#for i in range(arrayMaxLength):
		#var pos := MaskPos.new()
		#pos.pos = Vector2(-10000, -10000)
		#pos.radius = -10000
		#posList[i] = pos
		
	mat = material as ShaderMaterial
	
	#var maskPos = MaskPos.new()
	#maskPos.pos = Vector2(100, 100)
	#maskPos.radius = 40
	#posList[1].pos = Vector2(100, 100)
	#posList[1].radius = 40
	#posList[1].worldBit = 1.0
	#
	#posList[2].pos = Vector2(200, 200)
	#posList[2].radius = 50
	setPosAndRad()
	pass # Replace with function body.



#func _unhandled_input(input_event: InputEvent) -> void:
func _unhandled_input(input_event: InputEvent) -> void:
	# If tool enabled, we don't want to handle our input in the editor.
	if Engine.is_editor_hint():
		return

	if input_event is InputEventKey and input_event.pressed and not input_event.echo:
		if input_event.keycode == KEY_SHIFT:
			invert_world_debug = !invert_world_debug
		if input_event.keycode == KEY_CTRL:
			invert_world = !invert_world
			
			
	if input_event is InputEventMouseMotion or input_event is InputEventMouseButton:
		mouse_pos = input_event.global_position
		#print_debug("mouse_pos", mouse_pos.x, ",", mouse_pos.y)

	if input_event is InputEventMouseButton and input_event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
		mouse_pressed = input_event.pressed
		
	if input_event is InputEventMouseButton:
		if input_event.button_index == MouseButton.MOUSE_BUTTON_WHEEL_UP:
			mouse_scroll *=1.1
			print("Mausrad hoch")
			# Aktion: z.B. Zoom In
		elif input_event.button_index == MouseButton.MOUSE_BUTTON_WHEEL_DOWN:
			mouse_scroll *=0.9
			print("Mausrad runter")
			# Aktion: z.B. Zoom Oout#

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#if (mouse_pressed):
		#posList[0].pos = mouse_pos
	#posList[0].radius = mouse_scroll * 100
	#posList[0].worldBit = invert_world_debug if 1 else 0
	setPosAndRad()
	material.set_shader_parameter("invert_world", invert_world)
	material.set_shader_parameter("time_millis", Time.get_ticks_msec())
	
	pass
