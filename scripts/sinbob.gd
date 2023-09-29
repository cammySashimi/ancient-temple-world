extends Node3D

@onready var root_y = owner.position.y

@export var start_offset = 0
@export var bob_frequency = 0.02
@export var bob_amplitude = 0.1
@export var rotation_speed = 0.025
@export var stop_on_pause = true

func _process(_delta):
	if (!stop_on_pause) or (stop_on_pause and !global.game_paused):
		owner.position.y = root_y + (sin((global.time+start_offset) * bob_frequency) * bob_amplitude)
		owner.rotation.y += rotation_speed
