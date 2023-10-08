extends Control

@onready var world = $SubViewportContainer/SubViewport/World
@onready var showfps = false

@onready var pausebg = self.get_node("UICanvas/PauseBG")
@onready var handcurs = self.get_node("UICanvas/HandCursor")
@onready var mouthcurs = self.get_node("UICanvas/MouthCursor")
@onready var fpsmeter = self.get_node("UICanvas/FPSMeter")
@onready var urncounter = self.get_node("UICanvas/PauseBG/Icons/UrnIcon/UrnScore")
@onready var breadcounter = self.get_node("UICanvas/PauseBG/Icons/BreadIcon/BreadScore")
#@onready var code = self.get_node("UICanvas/Code")

# Called when the node enters the scene tree for the first time.
func _ready():
	# Required to change the 3D viewport's size when the window is resized.
	self.get_node("UICanvas/PauseBG").hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# Update urn counter text
	urncounter.text = str(world.urn_score)
	breadcounter.text = str(world.bread_score)
	
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
