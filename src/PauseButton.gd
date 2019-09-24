extends Button


func _ready():
	
	pass

func changeColor(color):
	get_node("Container/PauseBlock").set_modulate(color)
	get_node("Container/PauseBorders").set_modulate(Color(1-color.r,1-color.g,1-color.b))
