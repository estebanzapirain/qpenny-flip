extends KinematicBody2D

const ANIMATED_TYPES = ["on", "turning_off"]

const POS_INI = Vector2(342,619)
const POS_FIN = Vector2(342,168)

var hadamardBuff = false
var velocity = 200

var pos_llegada = POS_FIN

func _ready():
   set_process_input(false)
   Had_PU_visuals_disable()
   hide()
   moverse()
   detenerse()

func _physics_process(delta):
	var vec
	if(get_position().distance_to(pos_llegada) <= 10):
		cambiaPosLlegada()
	vec = (pos_llegada - get_position()).normalized()
	move_and_collide(vec * velocity * delta)

func cambiaPosLlegada():
	if(pos_llegada == POS_FIN):
		pos_llegada = POS_INI
	else: #(pos_llegada == POS_INI)
		pos_llegada = POS_FIN

func moverse():
	set_physics_process(true)

func detenerse():
	set_physics_process(false)


func _on_ZonaNoTocable_body_enter( body ):
	body.setUntouchable()
	if hadamardBuff:
		body.activateHBuff()
	body.turnoCPU()


func _on_ZonaNoTocable_body_exit( body ):
	body.setTouchable()
	body.terminaTurnoCPU()

func appear():
    _on_TurnOffHPUTimer_timeout()
    show()

func disappear():
    hide()

func setHadamard(cond):
    hadamardBuff = cond


func activateHadamard():
    CoinGlobals.setHad_PU_on(true)
    setHadamard(true)
    get_node("TurnOffHPUTimer").start()
    get_node("AnimationChangeTimer").set_wait_time( get_node("TurnOffHPUTimer").get_wait_time() - 2)
    get_node("AnimationChangeTimer").start()
    Had_PU_visuals_enable()

func deactivateHadamard():
	setHadamard(false)
	CoinGlobals.setHad_PU_on(false)
	Had_PU_visuals_disable()

func _on_TurnOffHPUTimer_timeout():
	deactivateHadamard()


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
	get_node("AnimatedSpriteUp").animation       = ANIMATED_TYPES[1]
	get_node("AnimatedSpriteDown").animation     = ANIMATED_TYPES[1]
	get_node("AnimatedSpriteLineUp").animation   = ANIMATED_TYPES[1]
	get_node("AnimatedSpriteLineDown").animation = ANIMATED_TYPES[1]


