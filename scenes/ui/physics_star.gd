extends Node2D

var mouseon = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event):
	if mouseon:
		if event is InputEventMouseButton:
			$RigidBody2D.freeze = false

func _physics_process(_delta):
	pass

func _on_rigid_body_2d_mouse_entered():
	mouseon = true

func _on_rigid_body_2d_mouse_exited():
	mouseon = false
