extends Node

const BASE_GAME_TIME = 30
const CANT_LEVELS = 24
const CANT_LEVELS_ENDLESS = 42
const CANT_WORLDS = 3
const VERSION = "1.2"


enum GAME_MODES{
	ARCADE,
	ENDLESS
}

#Layers
#1=zonaNoTocable
#20=Touch


var SCREEN_WIDTH = ProjectSettings.get("display/window/size/width") #OS.get_window_size().x #viewport.get_width()
var SCREEN_HEIGHT = ProjectSettings.get("display/window/size/height") #OS.get_window_size().y
var SCREEN_WIDTH_FIX = SCREEN_WIDTH - CoinGlobals.COIN_WIDHT

var paused 
var level_starting
#var actual_screen = SCREEN_TYPES.INITIAL_MENU
var current_color           setget setCurrentColor, getCurrentColor
var current_color_comp      setget , getCurrentColorComp
var colors_loaded = false   setget setColorsLoaded, isColorsLoaded

var to_ls_menu = false      setget set_to_ls_menu, is_to_ls_menu

var game_mode               
var world_act = 1           setget set_world_act, get_world_act
var level_act               setget set_level_act, get_level_act

func _ready():
	pass

func setPaused(cond):
	paused = cond

func isPaused():
	return paused

func is_game_mode_arcade():
	return game_mode == GAME_MODES.ARCADE

func is_game_mode_endless():
	return game_mode == GAME_MODES.ENDLESS

func set_game_mode_arcade():
	game_mode = GAME_MODES.ARCADE

func set_game_mode_endless():
	game_mode = GAME_MODES.ENDLESS

func setLevel_starting(cond):
	level_starting = cond

func isLevel_Starting():
	return level_starting

func setCurrentColor(color):
	current_color = color
	current_color_comp = Color(1 - color.r, 1 - color.g, 1 - color.b)

func getCurrentColor():
	return current_color


func getCurrentColorComp():
	return current_color_comp


func setColorsLoaded(cond):
	colors_loaded = cond

func isColorsLoaded():
	return colors_loaded

#func set_actual_screen(scr_type):
#	actual_screen = scr_type

func set_world_act(nWorld):
	world_act = nWorld

func get_world_act():
	return world_act

func set_level_act(nLevel):
	level_act = nLevel

func get_level_act():
	return level_act

func set_to_ls_menu(cond):
	to_ls_menu = cond

func is_to_ls_menu():
	if(to_ls_menu):
		to_ls_menu = false
		return true
	else:
		return false



