extends Control

const ANIMATED_TYPES = ["unfilled", "filled"]

var currentStar = 1
var effectTypes = ["","",""]
var volumeDb = [17,20,23]

func _ready():
	hide_stars()

func hide_stars():
	get_node("Star1").hide()
	get_node("Star2").hide()
	get_node("Star3").hide()
	hide() #tiene que estar para que el container del pause menu detecte que no esta

func show_stars():
	show() #tiene que estar para que el container del pause menu detecte que esta
	get_node("Star1").show()
	get_node("Star2").show()
	get_node("Star3").show()

func show_stars_anim():
	show()   #tiene que estar para que el container del pause menu detecte que esta
	get_node("ShowStarTimer").start()



func update_stars_cant(cantStars):
    if cantStars == 3:
        change_anim_stars(1, 1, 1)
        effectTypes[0] = "FilledEffect"
        effectTypes[1] = "FilledEffect"
        effectTypes[2] = "FilledEffect"
    elif cantStars == 2:
        change_anim_stars(1, 1, 0)
        effectTypes[0] = "FilledEffect"
        effectTypes[1] = "FilledEffect"
        effectTypes[2] = "UnfilledEffect"
    elif cantStars == 1:
        change_anim_stars(1, 0, 0)
        effectTypes[0] = "FilledEffect"
        effectTypes[1] = "UnfilledEffect"
        effectTypes[2] = "UnfilledEffect"
    else: 
        change_anim_stars(0, 0, 0)
        effectTypes[0] = "UnfilledEffect"
        effectTypes[1] = "UnfilledEffect"
        effectTypes[2] = "UnfilledEffect"

func change_anim_stars(anim1, anim2, anim3):
        get_node("Star1").animation = ANIMATED_TYPES[anim1]
        get_node("Star2").animation = ANIMATED_TYPES[anim2]
        get_node("Star3").animation = ANIMATED_TYPES[anim3]



func _on_ShowStarTimer_timeout():
	get_node("Star" + str(currentStar)).show()
	
	get_node(effectTypes[currentStar - 1]).set_volume_db(volumeDb[currentStar - 1])
	get_node(effectTypes[currentStar - 1]).play(0)
	
	if currentStar < 3:
		currentStar += 1
	else: #currentStar == 3
		get_node("ShowStarTimer").stop()
		currentStar = 1


