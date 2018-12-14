extends Area2D

const ANIMATED_TYPES = ["on", "turning_off"]

var hadamardBuff = false
var activated

func _ready():
   set_process_input(false)
   Had_PU_visuals_disable()
   hide()

func _on_AreaNoTocable_body_enter( body ):
	if activated:
		body.setUntouchable()
		if hadamardBuff:
			body.activateHBuff()
		body.turnoCPU()


func _on_AreaNoTocable_body_exit( body ):
	if activated:
		body.setTouchable()
		body.terminaTurnoCPU()

func appear():
    _on_TurnOffHPUTimer_timeout()
    show()
    activated = true

func disappear():
    hide()
    activated = false

func setHadamard(cond):
    hadamardBuff = cond


func activateHadamard():
    CoinGlobals.setHad_PU_on(true)
    setHadamard(true)
    get_node("TurnOffHPUTimer").start()
    get_node("AnimationChangeTimer").set_wait_time( get_node("TurnOffHPUTimer").get_wait_time() - 2)
    get_node("AnimationChangeTimer").start()
    Had_PU_visuals_enable()


func _on_TurnOffHPUTimer_timeout():
    setHadamard(false)
    CoinGlobals.setHad_PU_on(false)
    Had_PU_visuals_disable()


func Had_PU_visuals_enable():
	Had_PU_element_visuals_enable("AnimatedSpriteUp")
	Had_PU_element_visuals_enable("AnimatedSpriteDown")
	Had_PU_element_visuals_enable("AnimatedSpriteLineUp")
	Had_PU_element_visuals_enable("AnimatedSpriteLineDown")

func Had_PU_element_visuals_enable(strIdElem):
	get_node(strIdElem).animation = ANIMATED_TYPES[0]
	get_node(strIdElem).show()
	get_node(strIdElem).play()

func Had_PU_visuals_disable():
	Had_PU_element_visuals_disable("AnimatedSpriteUp")
	Had_PU_element_visuals_disable("AnimatedSpriteDown")
	Had_PU_element_visuals_disable("AnimatedSpriteLineUp")
	Had_PU_element_visuals_disable("AnimatedSpriteLineDown")

func Had_PU_element_visuals_disable(strIdElem):
	get_node(strIdElem).stop()
	get_node(strIdElem).hide()

func _on_AnimationChangeTimer_timeout():
	get_node("AnimatedSpriteUp").animation = ANIMATED_TYPES[1]
	get_node("AnimatedSpriteDown").animation = ANIMATED_TYPES[1]
	get_node("AnimatedSpriteLineUp").animation = ANIMATED_TYPES[1]
	get_node("AnimatedSpriteLineDown").animation = ANIMATED_TYPES[1]

