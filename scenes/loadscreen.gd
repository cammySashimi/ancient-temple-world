extends Node3D

var load_status = 0
var scene = "res://scenes/world.tscn"
var progress = []

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	ResourceLoader.load_threaded_request(scene)

func _process(_delta):
	load_status = ResourceLoader.load_threaded_get_status(scene, progress)
	if load_status == ResourceLoader.THREAD_LOAD_LOADED:
		await get_tree().create_timer(0.1).timeout
		get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(scene))
		queue_free()
