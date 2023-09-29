extends CharacterBody3D

# Player movement vars
var move_speed
var run_toggled = false
@export var walk_speed = 5.0
@export var run_speed = 7.0
@export var jump_velocity = 4
@export var look_sensitivity = 0.006
@export var air_control_speed = 2
@export var ground_friction = 8
@export var wiggle_factor = 0.002

# Juice vars
@export var head_bob_frequency = 2
@export var head_bob_amplitude = 0.04

@export var interact_distance = 3
@export var dialog_close_distance = 5

var bob_time = 0
var interacting_with = null
var dialog = null

var jump_boost = 0
var run_boost = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# Ancient blood rituals
@onready var world = get_node("/root/World")

@onready var head = get_node("Head")
@onready var camera = get_node("Head/Camera3D")
@onready var hand_l = get_node("Head/Camera3D/LeftHand")
@onready var hand_r = get_node("Head/Camera3D/RightHand")

@onready var ui = get_node("/root/World/UI")
@onready var hand_curs = get_node("/root/World/UI/UICanvas/HandCursor")
@onready var mouth_curs = get_node("/root/World/UI/UICanvas/MouthCursor")

@onready var music_crossfade = $"../Music/CrossFade"

@onready var home_position = position

func _ready():
	# Capture mouse for first-person camera
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		if !global.game_paused:
			# Rotate camera
			head.rotate_y(-event.relative.x * look_sensitivity)
			camera.rotate_x(-event.relative.y * look_sensitivity)
			
			# Clamp rotation
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-88), deg_to_rad(88))

func _physics_process(delta):
	
	# Is there a dialog box open?
	dialog = get_node_or_null("/root/World").dialog
	
	# Toggle fullscreen if button is pressed
	if Input.is_action_just_pressed("toggle_fullscreen"):
		var mode = DisplayServer.window_get_mode()
		if mode == DisplayServer.WINDOW_MODE_WINDOWED:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	
		# Close textbox if we gotta
	if interacting_with:
		if global_position.distance_to(interacting_with.global_position) > dialog_close_distance:
			if dialog != null:
				interacting_with = null
				dialog.queue_free()
	
	# If game isn't paused:
	if !global.game_paused:
		
		# Add the gravity.
		if not is_on_floor():
			velocity.y -= gravity * delta
		
		# Change cursor based on where player is pointing
		hand_curs.show()
		mouth_curs.hide()
		var pointed = _get_pointed()
		if pointed != null:
			var pointed_parent = pointed.collider.owner
			if pointed_parent.has_method("interact"):
				hand_curs.hide()
				mouth_curs.show()
		
		# Set speed based on run state
		if Input.is_action_pressed("move_run") or run_toggled:
			move_speed = run_speed + run_boost
		else:
			move_speed = walk_speed
		
		# Handle run toggle.
		if Input.is_action_just_pressed("move_run_toggle"):
			run_toggled = !run_toggled
		
		# Handle Jump.
		if Input.is_action_just_pressed("move_jump"):
			_jump()
		
		# Handle clicky talky
		if Input.is_action_just_pressed("talk"):
			_get_clicked()

		# Warp home if we press the button or are falling into the void
		if Input.is_action_just_pressed("warp_home") or position.y < -500:
			position = home_position
		
		# Open menu if we gotta
		if Input.is_action_just_pressed("menu"):
			if dialog != null:
				interacting_with = null
				dialog.queue_free()
		
		# Move player
		_move_player(delta)
		move_and_slide()

# Headbobbing
func _headbob(time):
	var pos = Vector3.ZERO
	pos.y = sin(time * head_bob_frequency) * head_bob_amplitude
	pos.x = cos(time * head_bob_frequency / 2) * head_bob_amplitude
	return pos

func _handbob(time):
	var pos = Vector3.ZERO
	pos.y = sin(time * head_bob_frequency) * head_bob_amplitude
	pos.x = cos(time * head_bob_frequency / 2) * head_bob_amplitude
	return pos

func _move_player(delta):
	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	# If player is on the floor, let them have full movement control
	if is_on_floor():
		if direction:
			velocity.x = direction.x * move_speed
			velocity.z = direction.z * move_speed
		else:
			velocity.x = lerp(velocity.x, direction.x * move_speed, delta * ground_friction)
			velocity.z = lerp(velocity.z, direction.z * move_speed, delta * ground_friction)
	# Else, lerp towards desired direction
	else:
		velocity.x = lerp(velocity.x, direction.x * move_speed, delta * air_control_speed)
		velocity.z = lerp(velocity.z, direction.z * move_speed, delta * air_control_speed)
	
	bob_time += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(bob_time)

func _jump():
	if is_on_floor() and dialog == null:
		velocity.y = jump_velocity + jump_boost
	_wiggle()

# Wiggling, used to free player from buggy collisions
func _wiggle():
	position.x += randf_range(-wiggle_factor, wiggle_factor)
	position.z += randf_range(-wiggle_factor, wiggle_factor)

func _get_pointed():
	var space = get_world_3d().direct_space_state
	var camera_pos = camera.global_position
	var camera_trans = camera.global_transform
	
	var query = PhysicsRayQueryParameters3D.create(camera_pos, camera_pos - camera_trans.basis.z * interact_distance)
	var collision = space.intersect_ray(query)
	if collision:
		return collision
	else:
		return null

# Get object interacted with
func _get_clicked():
	var space = get_world_3d().direct_space_state
	var camera_pos = camera.global_position
	var camera_trans = camera.global_transform
	
	interacting_with = null
	
	var query = PhysicsRayQueryParameters3D.create(camera_pos, camera_pos - camera_trans.basis.z * interact_distance)
	var collision = space.intersect_ray(query)
	if collision:
		# Get parent node of what we clicked (scripts stored in sprite or model rather than area3d)
		var collision_parent = collision.collider.owner
		if collision_parent.has_method("interact"):
			interacting_with = collision_parent
			collision_parent.interact()

# Collisions
func _on_area_3d_area_entered(area):
	if area.is_in_group("music_fade"):
		if area.is_in_group("fade_to_cavern"):
			if global.now_playing != "cavern":
				music_crossfade.play("BGM2Cavern")
				global.now_playing = "cavern"
		if area.is_in_group("fade_to_bgm"):
			if global.now_playing != "bgm":
				music_crossfade.play("Cavern2BGM")
				global.now_playing = "bgm"
	
	if area.owner.is_in_group("beer_urn"):
		jump_boost += 0.4
		world.urn_score += 1
		area.owner.queue_free()
	
	elif area.owner.is_in_group("ancient_bread"):
		run_boost += 0.2
		world.bread_score += 1
		area.owner.queue_free()
	
	elif area.owner.is_in_group("seal"):
		if area.owner.is_in_group("seal_ostrich"):
			world.seals[0] = true
		elif area.owner.is_in_group("seal_stabby"):
			world.seals[1] = true
		elif area.owner.is_in_group("seal_goatmen"):
			world.seals[2] = true
		elif area.owner.is_in_group("seal_worship"):
			world.seals[3] = true
		elif area.owner.is_in_group("seal_sitman"):
			world.seals[4] = true
		elif area.owner.is_in_group("seal_dragons"):
			world.seals[5] = true
		elif area.owner.is_in_group("seal_beer"):
			world.seals[6] = true
		elif area.owner.is_in_group("seal_goats"):
			world.seals[7] = true
		elif area.owner.is_in_group("seal_rollercoaster"):
			world.seals[8] = true
		
		area.owner.queue_free()
