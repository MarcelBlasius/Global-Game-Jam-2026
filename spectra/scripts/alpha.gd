extends MeshInstance2D

var mat : ShaderMaterial
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mat = material as ShaderMaterial
	
	mat.set_shader_parameter("radius", 100.0)
	pass # Replace with function body.

var mouse_pos: Vector2
var mouse_pressed: bool = false

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
		
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	mat.set_shader_parameter("point", mouse_pos)
	pass
