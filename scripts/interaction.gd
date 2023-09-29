extends Node3D

@export var timeline = "timeline"

func interact():
	var dialog = get_node_or_null("/root/World").dialog
	if not dialog:
		get_node("/root/World").dialog = Dialogic.start(timeline, false)

