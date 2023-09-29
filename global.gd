extends Node

var game_paused = false
var time = 0
var now_playing = "bgm"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if !game_paused:
		time += 1
