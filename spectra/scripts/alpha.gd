extends MeshInstance2D

class MaskPos:
	var pos: Vector2
	var radius: float
	var worldBit : float

var mat : ShaderMaterial
var posList : Array[MaskPos]
const arrayMaxLength := 5
const arrayElementSize := 4

func setPosAndRad():
	var posVals := []
	posVals.resize(arrayMaxLength * arrayElementSize)
	
	for i in range(arrayMaxLength):
		posVals[i * 4] = posList[i].pos.x
		posVals[i * 4 + 1] = posList[i].pos.y
		posVals[i * 4 + 2] = posList[i].radius
		posVals[i * 4 + 3] = posList[i].worldBit
		
	material.set_shader_parameter("posValues", posVals)
	material.set_shader_parameter("value_count", arrayMaxLength)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	posList.resize(arrayMaxLength)
	for i in range(arrayMaxLength):
		var pos := MaskPos.new()
		pos.pos = Vector2(-10000, -10000)
		pos.radius = -10000
		posList[i] = pos
		
	mat = material as ShaderMaterial
	
	#var maskPos = MaskPos.new()
	#maskPos.pos = Vector2(100, 100)
	#maskPos.radius = 40
	posList[1].pos = Vector2(100, 100)
	posList[1].radius = 40
	posList[1].worldBit = 0.0
	
	posList[2].pos = Vector2(200, 200)
	posList[2].radius = 50
	setPosAndRad()
	pass # Replace with function body.

var mouse_pos: Vector2
var mouse_pressed: bool = false
var mouse_scroll: float = 1
var invert_world: bool = false;

#func _unhandled_input(input_event: InputEvent) -> void:
func _unhandled_input(input_event: InputEvent) -> void:
	# If tool enabled, we don't want to handle our input in the editor.
	if Engine.is_editor_hint():
		return

	if input_event is InputEventKey and input_event.pressed and not input_event.echo:
		if input_event.keycode == KEY_SHIFT:
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
			# Aktion: z.B. Zoom Oout
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if (mouse_pressed):
		posList[0].pos = mouse_pos
	posList[0].radius = mouse_scroll * 100
	posList[0].worldBit = invert_world if 1 else 0
	setPosAndRad()
	
	pass
