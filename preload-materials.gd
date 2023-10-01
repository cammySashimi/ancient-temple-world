# Create a Scene with a Node
# Add this script to it
# Add the Scene to the Autoloads
# Fulfill the material Array with all the Materials that are causing freeze
# It also works with Materials from ParticlesSystems

# preload_materials.gd
extends Node

# Load the array through Inspector
@export var materials: Array[Material]

func _ready():
	_load_materials()

func _load_materials():
	var sprites = []
	for material in materials:
		print("spriteify")
		var sprite = Sprite2D.new()
		sprite.texture = PlaceholderTexture2D.new()
		sprite.material = material
		add_child(sprite)
		sprites.append(sprite)
	# Remove the sprites after being rendered
	await get_tree().create_timer(2).timeout
	for sprite in sprites:
		print("spriteify KILL")
		sprite.queue_free()
