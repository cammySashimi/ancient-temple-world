extends OmniLight3D

var flicker_dir = 1
var flicker_strength = 0.1
var light_min = 4
var light_max = 8

func _process(_delta):
	# Randomly swap flicker dir
	if (randf() < 0.1) or (self.light_energy > light_max) or (self.light_energy < light_min):
		flicker_dir *= -1
	
	self.light_energy += (flicker_strength * flicker_dir)
