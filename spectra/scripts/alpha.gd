extends MeshInstance2D

var mat : ShaderMaterial
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mat = material as ShaderMaterial
	pass # Replace with function body.

var mouse_pos: Vector2
var mouse_pressed: bool = false
var mouse_scroll: float = 1

#func _unhandled_input(input_event: InputEvent) -> void:
func _input(input_event: InputEvent) -> void:
	# If tool enabled, we don't want to handle our input in the editor.
	if Engine.is_editor_hint():
		return

	
	if input_event is InputEventMouseMotion or input_event is InputEventMouseButton:
		mouse_pos = input_event.global_position
		print_debug("mouse_pos", mouse_pos.x, ",", mouse_pos.y)

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
			# Aktion: z.B. Zoom Out
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if (mouse_pressed):
		mat.set_shader_parameter("point", mouse_pos)
	mat.set_shader_parameter("radius", mouse_scroll * 100)
	pass
