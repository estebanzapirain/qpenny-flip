extends RigidBody2D


const COIN_BASE_TYPES = ["white", "black"]
const COIN_HADAMARD_BLACK_TYPES = ["hadamard_black_1", "hadamard_black_2"]
const COIN_HADAMARD_WHITE_TYPES = ["hadamard_white_1", "hadamard_white_2"]

export (int) var min_speed # Minimum speed range.
export (int) var max_speed # Maximum speed range.

var state
var stateAnt
var touchable = true
var coinHBuffed = false
var probFlipCPU = 0.5

func _ready():
    if(!CoinGlobals.isHad_PU_on()):
        state = randi() % 2
    else:   #si esta actuvado el power up de hadamard siempre salen negras
        state = 1
    get_node("AnimatedSprite").animation = COIN_BASE_TYPES[state]
    get_node("AnimatedSprite").play()
    set_process_input(true)

func setUntouchable():
    touchable = false

func setTouchable():
    touchable = true

func setMinMaxSpeed( speed, amplitude ):
    min_speed = speed
    max_speed = speed + amplitude

func _input_event(viewport, event, shape_idx):
    if !QPFGlobals.isPaused() and touchable and event.type == InputEvent.MOUSE_BUTTON:
            if event.button_index == BUTTON_LEFT and event.pressed:
                flip()

func flip():
    if !touchable:
        state = (state + 1) % 2
    elif touchable and state == 0:
        state = (state + 1) % 2
        get_node("FlipSound").play()
        
    if !coinHBuffed:
        get_node("AnimatedSprite").animation = COIN_BASE_TYPES[state]
    else:
        if stateAnt == 1:
            get_node("AnimatedSprite").animation = COIN_HADAMARD_BLACK_TYPES[state]
        else: #stateAnt == 0:
            get_node("AnimatedSprite").animation = COIN_HADAMARD_WHITE_TYPES[state]

func turnoCPU():
    var timer = get_node("TimerCPUFlips")
    timer.connect("timeout", self, "intentoCPU")
    timer.set_wait_time(rand_range(CoinGlobals.getMin_CPU_Try_WT(),CoinGlobals.getMax_CPU_Try_WT()))
    timer.start()

func intentoCPU():        
    var juegaCPU = (randi() % 101) <= probFlipCPU * 100  
    if juegaCPU and stateAnt == 1:
        flip()

func terminaTurnoCPU():
    get_node("TimerCPUFlips").stop()
    if coinHBuffed:       #pasa a negro al salir de la zona prohibida
        coinHBuffed = false
        state = stateAnt
        get_node("AnimatedSprite").animation = COIN_BASE_TYPES[state]

func activateHBuff():
    stateAnt = state
    coinHBuffed = true
    if stateAnt == 1:
        get_node("AnimatedSprite").animation = COIN_HADAMARD_BLACK_TYPES[state]
    else: #stateAnt == 0:
        get_node("AnimatedSprite").animation = COIN_HADAMARD_WHITE_TYPES[state]

func _on_Visibility_exit_screen():
	queue_free()



