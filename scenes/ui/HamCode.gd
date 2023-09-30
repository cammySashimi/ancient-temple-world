extends Label

var codenum = 0
var textwidth = 900

# Called when the node enters the scene tree for the first time.
func _ready():
	text = hammurabi.code[codenum]
	textwidth = size.x

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if visible:
		position.x -= 2
		if position.x == 0:
			#textwidth:
			var nexttext = preload("res://scenes/utility/code_bit.tscn").instance()
			nexttext.init()
			nexttext.codenum = codenum + 1
			nexttext.text = hammurabi.code[nexttext.codenum]
			textwidth = size.x
			print(str(textwidth))
			position.x = 20
		elif position.x <= -textwidth:
			queue_free()
			
