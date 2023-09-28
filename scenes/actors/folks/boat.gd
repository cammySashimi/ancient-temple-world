extends Node3D

var time = 0
var bob_frequency = 0.02
var bob_amplitude = 0.5

@onready var root_y = position.y
@onready var ui = $"../../../UI"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if !ui.game_paused:
		time += 1
		position.y = root_y + (sin(time * bob_frequency) * bob_amplitude)

func interact():
	var dialog = get_node_or_null("/root/World").dialog
	if not dialog:
		get_node("/root/World").dialog = Dialogic.start("littleguytimeline", false)
