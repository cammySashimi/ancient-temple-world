extends Resource

const SAVE_PATH = "user://atw_save.tres"

@export var seals = []
@export var breads = []
@export var beers = []
@export var player_position: Vector3

func save_game():
	#ResourceSaver.save(SAVE_PATH, self)
	pass

func load_game():
	if ResourceLoader.exists(SAVE_PATH):
		return load(SAVE_PATH)
	else:
		return null
