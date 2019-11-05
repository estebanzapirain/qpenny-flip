extends Node


const BASE_COIN_TIMER_WT = 1
const COIN_TIMER_WT_DEC_RATE = 0.45 / (24 - 1)
#Es cant a decrementar / (cantNiveles - 1)


const DEFAULT_CANT_LIVES_EM = 3

const X_INI_ZONA_TRIGGER_FP = -132
const Y_INI_ZONA_TRIGGER_FP = 1384.5


onready var hud
onready var hadPUTimer = $Timers/HadPowUpTimer
onready var hadamardPU = $HadamardPowUp
onready var coinTimer = $Timers/CoinTimer





var Coin = load("res://Coin.tscn")
var ZonaNoTocable = load("res://ZonaNoTocable.tscn")
var ZonaTriggerFP = load("res://ZonaTrigger.tscn")



var zonaNoTocableAct 
var zonaTriggerFPAct

var score = 0
var playtime
var levelAct

var timeInEndless = 0
var lives = DEFAULT_CANT_LIVES_EM
var colorLevel

enum GAME_SCREEN{
	IN_GAME,
	GAME_ENDING,
	GAME_ENDED
}



var game_screen = GAME_SCREEN.IN_GAME

var minCoinSpeed
var maxCoinSpeed

var minHad_PU_WT
var had_PU_WT_Amp


func _ready():
	get_tree().set_auto_accept_quit(false) #it prevents game closing when back bt is pressed
	levelAct = GameGlobals.get_level_act()
	GameGlobals.setColorsLoaded(false) #para que tenga que cambiar de color cuando vuelve de las partidas
	


#<---------------------------Admin gral--------------------------

func setGameScreen(gameScreen):
	game_screen = gameScreen

func creaZonaNoTocable():
	zonaNoTocableAct = ZonaNoTocable.instance()
	add_child(zonaNoTocableAct)
	zonaNoTocableAct.appear()

func update_Prob_Flip_CPU(level):
	CoinGlobals.updateProbFlipCPU(level)

func _on_CoinTimer_timeout():
	var coin = Coin.instance()
	add_child(coin)
	coin.setMinMaxSpeed( minCoinSpeed, maxCoinSpeed )
	coin.dropFromAboveRand()

func _on_HadPowUpTimer_timeout():
    hadPUTimer.set_wait_time( minHad_PU_WT + (randi() % int(had_PU_WT_Amp)) )
    hadamardPU.dropFromAboveRand()

func update_CoinSpeeds(level):
	minCoinSpeed = CoinGlobals.BASE_MIN_COIN_SPEED + CoinGlobals.COIN_MIN_SPEED_INC_RATE * (level - 1)
	maxCoinSpeed = minCoinSpeed + CoinGlobals.BASE_COIN_SPEED_AMP + CoinGlobals.COIN_SPEED_AMP_INC_RATE * (level - 1)
	#maxCoinSpeed = minCoinSpedd + speedAmplitude

func update_Had_PU_Speeds(level):
	hadamardPU.update_Speeds(level)

func update_Had_PU_WT():
	minHad_PU_WT = CoinGlobals.BASE_MIN_HAD_PU_WT + CoinGlobals.MIN_HAD_PU_TIMER_WT_INC_RATE * (levelAct - 1)
	had_PU_WT_Amp = CoinGlobals.BASE_HAD_PU_WT_AMP + CoinGlobals.HAD_PU_TIMER_WT_AMP_INC_RATE * (levelAct - 1)


func activateHadPU():
	zonaNoTocableAct.activateHadamard()


func borraZonaNoTocable():
	if(zonaNoTocableAct != null):
		call_deferred("remove_child", zonaNoTocableAct)
		zonaNoTocableAct.queue_free() #also removes connected signals
		zonaNoTocableAct = null

func borraZonaTriggerFP():
	if(zonaTriggerFPAct != null):
		call_deferred("remove_child", zonaTriggerFPAct)
		zonaTriggerFPAct.queue_free()
		zonaTriggerFPAct = null

func _on_HUD_back_to_main_menu():
	cambia_escena("res://MainMenu.tscn")

func cambia_escena(scenePath):
	get_tree().change_scene(scenePath)



func goBackToMainMenu():
	hud.goBackToMainMenu()

func pause():
	hud.pause()

#<---------------------------Admin gral--------------------------




