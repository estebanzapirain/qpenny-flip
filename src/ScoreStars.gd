extends Control

const ANIMATED_TYPES = ["unfilled", "filled"]

var currentStar = 1

func _ready():
	hide_stars()

func hide_stars():
	get_node("Star1").hide()
	get_node("Star2").hide()
	get_node("Star3").hide()

func show_stars():
	get_node("Star1").show()
	get_node("Star2").show()
	get_node("Star3").show()

func show_stars_anim():
	get_node("ShowStarTimer").start()



func update_stars_cant(cantStars):
    if cantStars == 3:
        change_anim_stars(1, 1, 1)
    elif cantStars == 2:
        change_anim_stars(1, 1, 0)
    elif cantStars == 1:
        change_anim_stars(1, 0, 0)
    else: 
        change_anim_stars(0, 0, 0)

func change_anim_stars(anim1, anim2, anim3):
        get_node("Star1").animation = ANIMATED_TYPES[anim1]
        get_node("Star2").animation = ANIMATED_TYPES[anim2]
        get_node("Star3").animation = ANIMATED_TYPES[anim3]



func _on_ShowStarTimer_timeout():
	get_node("Star1").show()
	get_node("Star" + str(currentStar)).show()
	if currentStar < 3:
		currentStar += 1
	else: #currentStar == 3
		get_node("ShowStarTimer").stop()
		currentStar = 1
