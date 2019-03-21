extends Node

const BASE_GAME_TIME = 60
const CANT_LEVELS = 24
const CANT_LEVELS_ENDLESS = 39
const CANT_WORLDS = 3
const VERSION = "1.0.0"

enum SCREEN_TYPES{
	INITIAL_MENU,
	HELP,
	LEVEL_SELECT,
	IN_GAME,
	GAME_ENDING,
	GAME_ENDED,
	ENDLESS_MODE,
	GAME_ENDING_ENDLESS,
	GAME_ENDED_ENDLESS,
	CREDITS
}




var paused 
var level_starting
var actual_screen = SCREEN_TYPES.INITIAL_MENU
var world_act = 1

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

func get_world_act():
	return world_act


