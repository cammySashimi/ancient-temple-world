extends Sprite3D

func interact():
	var dialog = get_node_or_null("/root/World").dialog
	if not dialog:
		get_node("/root/World").dialog = Dialogic.start("guytimeline", false)
