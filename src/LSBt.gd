extends Button

var numLevel

func _ready():
	pass

#this must be called right after instancing the button
func init_button(num):
	numLevel = num
	set_text(str(num))
	get_node("PadlockSprite").hide()

func disable(cond):
	if(cond): 
		get_node("PadlockSprite").show()
		get_node("ScoreStars").hide()
	else:
		get_node("PadlockSprite").hide()
		get_node("ScoreStars").show()
	set_disabled(cond)

func update_stars_cant(cantStars):
	get_node("ScoreStars").update_stars_cant(cantStars)

func show_stars():
	get_node("ScoreStars").show_stars()

func getNumLevel():
	return numLevel