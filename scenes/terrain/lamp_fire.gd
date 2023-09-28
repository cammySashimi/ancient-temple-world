extends MeshInstance3D

var time = 0
var bob_frequency = 0.02
var bob_amplitude = 0.02
var rotation_speed = 0.1
var tilt_factor = 0.05

@onready var root_y = position.y
@onready var root_rot_x = rotation.x
@onready var root_rot_z = rotation.z

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	time += 1
	
	position.y = root_y + (sin(time * bob_frequency) * bob_amplitude)
	
	rotation.y += rotation_speed
	
	rotation.x = root_rot_x + randf_range(-tilt_factor, tilt_factor)
	rotation.z = root_rot_z + randf_range(-tilt_factor, tilt_factor)
