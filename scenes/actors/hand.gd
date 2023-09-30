extends Sprite3D

@export var time = 0.0
@export var bob_frequency = 0.01
@export var bob_amplitude = 0.04

@onready var root_y = position.y

@onready var player = $"../../.."

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if !global.game_paused:
		time += player.velocity.length()
		position.y = root_y + (sin(time * bob_frequency) * bob_amplitude)
