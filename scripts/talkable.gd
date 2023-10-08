extends Node

@export var dialog_timeline: DialogicTimeline

func interact():
	var dialog = get_node_or_null(global.world).dialog
	if not dialog:
		get_node(global.world).dialog = Dialogic.start(dialog_timeline, false)
