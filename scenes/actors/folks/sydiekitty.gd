extends Node3D

#var time = 0
#var bob_frequency = 0.02
#var bob_amplitude = 0.1
#var rotation_speed = 0.0
#
#@onready var root_y = position.y

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
#	time += 1
#
#	position.y = root_y + (sin(time * bob_frequency) * bob_amplitude)
#
#	rotation.y += rotation_speed

func interact():
	var dialog = get_node_or_null("/root/World").dialog
	if not dialog:
		get_node("/root/World").dialog = Dialogic.start("kittytimeline", false)
