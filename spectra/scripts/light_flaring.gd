extends PointLight2D

@export var flicker_speed: float = 4.0
@export var base_energy: float = 1.0
@export var flicker_intensity: float = 0.3

var noise = FastNoiseLite.new()
var time_passed: float = 0.0

func _ready() -> void:
	# Initialize noise settings for a "jagged" but continuous feel
	noise.seed = randi()
	noise.frequency = 0.5

func _process(delta: float) -> void:
	time_passed += delta * flicker_speed
	
	# Get a noise value between -1 and 1
	var sampled_noise = noise.get_noise_1d(time_passed)
	
	# Apply the noise to the light's energy
	energy = base_energy + (sampled_noise * flicker_intensity)
