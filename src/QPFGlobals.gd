extends Node

const BASE_GAME_TIME = 40
const CANT_LEVELS = 24
enum SCREEN_TYPES{
	INITIAL_MENU,
	HELP,
	LEVEL_SELECT,
	IN_GAME
}

var paused 
var level_starting
var actual_screen = SCREEN_TYPES.INITIAL_MENU

func _ready():
	pass

func setPaused(cond):
	paused = cond

func isPaused():
	return paused

func setLevel_starting(cond):
	level_starting = cond

func isLevel_Starting():
	return level_starting

func set_actual_screen(scr_type):
	actual_screen = scr_type


