extends Button

var points_next = true #if(points_next == false) --> it points back

func _ready():
	pass


#Pre: must be called right after instantiating
func point_back():
	points_next = false
	get_node("ArrowSprite").set_flip_h(true)


#Pre: must be called right after instantiating
func point_next():
	points_next = true
	get_node("ArrowSprite").set_flip_h(false)

func changeArrowColor( color ):
		get_node("ArrowSprite").modulate = color #change sprite color 
	                                             #to change properly must be originally white 
	                                             #also changes the child nodes color
	                                             #self_modulate to change only that node


