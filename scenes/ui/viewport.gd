extends SubViewportContainer

@onready var player = self.get_node("SubViewport/World/Player")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		if !global.game_paused:
			# Rotate camera
			player.head.rotate_y(-event.relative.x * player.look_sensitivity)
			player.camera.rotate_x(-event.relative.y * player.look_sensitivity)
			
			# Clamp rotation
			player.camera.rotation.x = clamp(player.camera.rotation.x, deg_to_rad(-88), deg_to_rad(88))

