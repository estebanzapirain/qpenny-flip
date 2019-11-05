extends "Droppable.gd"


const COIN_BASE_TYPES = ["white", "black"]
const COIN_HADAMARD_BLACK_TYPES = ["hadamard_black_1", "hadamard_black_2"]
const COIN_HADAMARD_WHITE_TYPES = ["hadamard_white_1", "hadamard_white_2"]


onready var animSprite = $AnimatedSprite
onready var timerCpuFlips = $TimerCPUFlips
onready var flipSound = $FlipSound

var state
var stateAnt
var touchable = true
var coinHBuffed = false
var activated = false setget set_activated,is_activated
#para controlar si un coin esta siendo usado o no

func _ready():
	set_process_input(true)
	general_setup()
	animSprite.play()
    
func is_activated():
	return activated

func set_activated(cond):
	activated = cond

func general_setup():
	if(!CoinGlobals.isHad_PU_on()):
		state = randi() % 2
	else:   #si esta actuvado el power up de hadamard siempre salen negras
		state = 1
	cambiaAnimacionBase() #para que coincida visualmente con el estado


func cambiaAnimacionBase():
	animSprite.animation = COIN_BASE_TYPES[state]


func setUntouchable():
	touchable = false

func setTouchable():
	touchable = true

func isTouchable():
	return touchable


func flip_sound():
	flipSound.play()


func flip():
	state = (state + 1) % 2
	flip_sound()      
	changeCoinAnim()

func flipCpu():
	state = (state + 1) % 2  
	changeCoinAnim()

func changeCoinAnim():
	if !coinHBuffed:
		animSprite.animation = COIN_BASE_TYPES[state]
	else:
		if stateAnt == 1:
			animSprite.animation = COIN_HADAMARD_BLACK_TYPES[state]
		else: #stateAnt == 0:
			animSprite.animation = COIN_HADAMARD_WHITE_TYPES[state]

func turnoCPU():
	stateAnt = state
	timerCpuFlips.connect("timeout", self, "intentoCPU")
	timerCpuFlips.set_wait_time(CoinGlobals.CPU_TRY_WT)
	timerCpuFlips.start()

func intentoCPU():        
	var juegaCPU = (randi() % 101) <= CoinGlobals.getProbFlipCPU() * 100  
	if juegaCPU and (state == 1 or ( coinHBuffed and stateAnt == 1) ):
		flipCpu()

func terminaTurnoCPU():
	timerCpuFlips.stop()
	if coinHBuffed:       #pasa a negro al salir de la zona prohibida
		coinHBuffed = false
		state = stateAnt
		animSprite.animation = COIN_BASE_TYPES[state]

func activateHBuff():
	stateAnt = state
	coinHBuffed = true
	if stateAnt == 1:
		animSprite.animation = COIN_HADAMARD_BLACK_TYPES[0]
	else: #stateAnt == 0:
		animSprite.animation = COIN_HADAMARD_WHITE_TYPES[0]

func isHBuffed():
	return coinHBuffed

#Pre: debe ser hijo de un CoinGenerator
func _on_Visibility_exit_screen():
	get_parent().deactivate_coin(self)


func setUpForMainMenu():
	setSpeed(CoinGlobals.MAIN_MENU_COIN_SPEED)

func setUpForCredits():
	setSpeed(CoinGlobals.CREDITS_COIN_SPEED)

func setUpForHelp():
	setSpeed(CoinGlobals.HELP_COIN_SPEED)



func _on_AreaTocable_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed():
		if(isTouchable()):
			flip()
