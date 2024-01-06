extends Control

@onready var world = $SubViewportContainer/SubViewport/World
@onready var showfps = false

@onready var pausebg = self.get_node("UICanvas/PauseBG")
@onready var handcurs = self.get_node("UICanvas/HandCursor")
@onready var mouthcurs = self.get_node("UICanvas/MouthCursor")
@onready var fpsmeter = self.get_node("UICanvas/FPSMeter")
@onready var urncounter = self.get_node("UICanvas/PauseBG/Icons/UrnIcon/UrnScore")
@onready var breadcounter = self.get_node("UICanvas/PauseBG/Icons/BreadIcon/BreadScore")
@onready var resbutton = $UICanvas/PauseBG/ResButton
@onready var player = self.get_node("SubViewportContainer/SubViewport/World/Player")
#@onready var code = self.get_node("UICanvas/Code")

@onready var viewport_container = get_node("SubViewportContainer")

var urntotal
var breadtotal

var scale_factor = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	# Required to change the 3D viewport's size when the window is resized.
	$UICanvas/FadeOut.visible = true
	self.get_node("UICanvas/PauseBG").hide()
	urntotal = get_tree().get_nodes_in_group("beer_urn").size()
	breadtotal = get_tree().get_nodes_in_group("ancient_bread").size()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# Update urn counter text
	urncounter.text = str(world.urn_score) + "/" + str(urntotal)
	breadcounter.text = str(world.bread_score) + "/" + str(breadtotal)
	
	if Input.is_action_just_pressed("cycle_viewport_resolution"):
		_on_res_button_pressed()

	if Input.is_action_just_pressed("toggle_fullscreen"):
		_on_fs_button_pressed()
	
	if Input.is_action_just_pressed("fps_toggle"):
		if showfps:
			showfps = false
			fpsmeter.hide()
		else:
			showfps = true
			fpsmeter.show()
	
	if Input.is_action_just_pressed("menu"):
		if !global.game_paused:
			global.game_paused = true
			pausebg.show()
			handcurs.hide()
			mouthcurs.hide()
			#code.hide()
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			var i = -1
			for seal in world.seals:
				i += 1
				if seal:
					match i:
						0:
							get_node("UICanvas/PauseBG/Seals/OstrichSeal/Cover").hide()
						1:
							get_node("UICanvas/PauseBG/Seals/StabbySeal/Cover").hide()
						2:
							get_node("UICanvas/PauseBG/Seals/GoatmenSeal/Cover").hide()
						3:
							get_node("UICanvas/PauseBG/Seals/WorshipSeal/Cover").hide()
						4:
							get_node("UICanvas/PauseBG/Seals/SitmanSeal/Cover").hide()
						5:
							get_node("UICanvas/PauseBG/Seals/DragonSeal/Cover").hide()
						6:
							get_node("UICanvas/PauseBG/Seals/BeerSeal/Cover").hide()
						7:
							get_node("UICanvas/PauseBG/Seals/GoatsSeal/Cover").hide()
						8:
							get_node("UICanvas/PauseBG/Seals/RollerCoasterSeal/Cover").hide()
		else:
			global.game_paused = false
			pausebg.hide()
			#scode.show()
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_quit_button_pressed():
	get_tree().quit()

func _on_res_button_pressed():
	scale_factor = wrapf(scale_factor + 1, 1, 6)
	viewport_container.stretch_shrink = scale_factor
	resbutton.text = "3D Scaling: " + str(snapped(1/scale_factor, 0.01)) + "x"

func _on_fs_button_pressed():
	var mode = DisplayServer.window_get_mode()
	if mode == DisplayServer.WINDOW_MODE_WINDOWED:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_warp_button_pressed():
	player.position = player.home_position

func _on_ostrich_warp_button_pressed():
	if world.seals[0]:
		player.position = world.sealwarp[0]

func _on_stabby_warp_button_pressed():
	if world.seals[1]:
		player.position = world.sealwarp[1]

func _on_goatmen_warp_button_pressed():
	if world.seals[2]:
		player.position = world.sealwarp[2]

func _on_worship_warp_button_pressed():
	if world.seals[3]:
		player.position = world.sealwarp[3]

func _on_sitman_warp_button_pressed():
	if world.seals[4]:
		player.position = world.sealwarp[4]

func _on_dragon_warp_button_pressed():
	if world.seals[5]:
		player.position = world.sealwarp[5]

func _on_beer_warp_button_pressed():
	if world.seals[6]:
		player.position = world.sealwarp[6]

func _on_goats_warp_button_pressed():
	if world.seals[7]:
		player.position = world.sealwarp[7]

func _on_rollercoaster_warp_button_pressed():
	if world.seals[8]:
		player.position = world.sealwarp[8]
