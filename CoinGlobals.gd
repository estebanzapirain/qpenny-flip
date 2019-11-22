extends Node

const COIN_WIDHT = 100
const CPU_TRY_WT = 0.8

const BASE_COIN_TIMER_WT = 1
const COIN_TIMER_WT_DEC_RATE = 0.45 / (24 - 1)
#Es cant a decrementar / (cantNiveles - 1)

const BASE_MIN_HAD_PU_WT = 10
const MIN_HAD_PU_TIMER_WT_INC_RATE = float(10) / (24 - 1)

const BASE_HAD_PU_WT_AMP = 3
const HAD_PU_TIMER_WT_AMP_INC_RATE = float(3) / (24 - 1)

const BASE_MIN_COIN_SPEED = 200
const COIN_MIN_SPEED_INC_RATE = float(100) / (24 - 1)

const BASE_COIN_SPEED_AMP = 25
const COIN_SPEED_AMP_INC_RATE = float(25) / (24 - 1)

const MAIN_MENU_COIN_SPEED = 400
const HELP_COIN_SPEED = 300
const CREDITS_COIN_SPEED = 500

const PROB_FLIP_BASE = 0.2
const PROB_FLIP_INC = 0.3 / (24 - 1)

const PROB_TAM1_BASE = 0.2

const PROB_TAM2_BASE = 0.5

const CANT_HELP_COIN_TYPES = 2
const CANT_TIPS = 3

var had_PU_on = false
var probFlipCPU = 0.33

var tipAct = 1
var helpCoinAct = 1
var creditsCoinType = [0,1,2,3]


var minCoinSpeed
var maxCoinSpeed

func _ready():
	pass

func getProbFlipCPU():
	return probFlipCPU

func setProbFlipCPU(value):
	probFlipCPU = value


func updateProbFlipCPU(level):
	probFlipCPU = PROB_FLIP_BASE + PROB_FLIP_INC  * (level - 1)

func setHad_PU_on(cond):
	had_PU_on = cond

func isHad_PU_on():
	return had_PU_on

#para iniciar una pantalla de ayuda nueva desde el inicio
func reset_help_tips():
	tipAct = 1

func reset_help_coin_act():
	helpCoinAct = 1


func setup_help_coin(coin):
	
	if(tipAct == 1): #black coin
		if(helpCoinAct == 1): #black unflipped
			coin.state = 1
			CoinGlobals.setProbFlipCPU(0) 
		else: #if (helpCoinAct == 2): #black flipped
			coin.state = 1
			CoinGlobals.setProbFlipCPU(1) 
	elif (tipAct == 2): #white coin
		coin.state = 0
	else: #if (tipAct == 3): #HadPU on
		if(helpCoinAct == 1): #black  HadPU on
			coin.state = 1
			CoinGlobals.setProbFlipCPU(1)
		else: #(helpCoinAct == 2): #white HadPU on
			coin.state = 0
	
	
	coin.cambiaAnimacionBase()  #para que coincida visualmente con el estado
	
	if (helpCoinAct == CANT_HELP_COIN_TYPES ):
		helpCoinAct = 1
	else:
		helpCoinAct += 1;

func getHelpTipAct():
	return tipAct

#Pre: control de que tipAct < CANT_TIPS antes de llamar 
func nextTip():
	tipAct += 1

#Pre: control de que tipAct >= 2 antes de llamar 
func prevTip():
	tipAct -= 1

func initCreditsCoinTypes():
	creditsCoinType = [0, 1, 2, 3]

func removeElementCreditsCoinType():
	var element
	var randIndex
	
	randIndex = randi() % creditsCoinType.size()
	element = creditsCoinType[randIndex]
	creditsCoinType.remove(randIndex)
	
	
	if(creditsCoinType.size() == 0):
		initCreditsCoinTypes()
	
	return element

func setup_credits_coin_state(coin):
	var creditsCoinType = removeElementCreditsCoinType()
	
	if(creditsCoinType == 0):
		coin.state = 0
		coin.setHBuffed(false)
		coin.cambiaAnimacionBase() #para que coincida visualmente con el estado
	elif(creditsCoinType == 1):
		coin.state = 1
		coin.setHBuffed(false)
		coin.cambiaAnimacionBase() #para que coincida visualmente con el estado
	else:
		if(creditsCoinType == 2):
			coin.state = 0
		else: #if(creditsCoinType == 3):
			coin.state = 1
		
		coin.activateHBuff()
	

func update_CoinSpeeds(level):
    minCoinSpeed = BASE_MIN_COIN_SPEED + COIN_MIN_SPEED_INC_RATE * (level - 1)
    maxCoinSpeed = minCoinSpeed + BASE_COIN_SPEED_AMP + COIN_SPEED_AMP_INC_RATE * (level - 1)
    #maxCoinSpeed = minCoinSpedd + speedAmplitude
