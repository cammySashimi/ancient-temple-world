extends Node

@export var dialog_timeline = ""

func interact():
	var dialog = get_node_or_null("/root/World").dialog
	if not dialog:
		get_node("/root/World").dialog = Dialogic.start(dialog_timeline, false)
