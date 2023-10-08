extends Node3D

var load_status = 0
var scene = "res://scenes/ui/ui.tscn"
var progress = []
var topprog = 0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	ResourceLoader.load_threaded_request(scene)

func _process(_delta):
	load_status = ResourceLoader.load_threaded_get_status(scene, progress)
	if progress[0] > topprog:
		topprog = progress[0]
	$Control/CanvasLayer/LoadText/LoadPercent.text = str(snapped(topprog*100, 1)) + "%"
	if load_status == ResourceLoader.THREAD_LOAD_LOADED:
		await get_tree().create_timer(0.1).timeout #idk why this works but this makes the materials pre-render
		get_tree().change_scene_to_file(scene)
		queue_free()
