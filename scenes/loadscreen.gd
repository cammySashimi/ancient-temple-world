extends Node3D

var load_status = 0
var scene = "res://scenes/ui/ui.tscn"
var physics_star_res = load("res://scenes/ui/physics_star.tscn")
var progress = []
var topprog = 0
var num_stars = 20
var star_positions = []

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	ResourceLoader.load_threaded_request(scene)
	place_stars(num_stars)

func _process(_delta):
	load_status = ResourceLoader.load_threaded_get_status(scene, progress)
	if progress[0] > topprog:
		topprog = progress[0]
	else:
		# dont tell
		topprog += 0.0005
	$Control/CanvasLayer/LoadText/LoadPercent.text = str(snapped(topprog*100, 1)) + "%"
	if load_status == ResourceLoader.THREAD_LOAD_LOADED:
		await get_tree().create_timer(0.1).timeout #idk why this works but this makes the materials pre-render
		get_tree().change_scene_to_file(scene)
		queue_free()

func place_stars(num):
	var starx
	var stary
	var space = 20
	for i in range(num):
		starx = randf_range(space, 1920-space)
		stary = randf_range(space, 1080-space)
		
		# make sure stars aren't on loadtext
		if (starx>700 and starx<1200 and stary>350 and stary<700):
			i -= 1
			continue

		var star = physics_star_res.instantiate()
		add_child(star)

		star.position.x = starx
		star.position.y = stary
