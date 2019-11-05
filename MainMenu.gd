extends Control

var LsButton = load("res://LSBt.tscn")

const INI_X_LS_BT = 40
const INC_X_LS_BT = 235
const INI_Y_LS_BT = 50
const INC_Y_LS_BT = 130

const CANT_LS_BT_Y = 8
const CANT_LS_BT_X = 3

var Coin = load("res://Coin.tscn")

onready var levelSelectMenu = $LevelSelectMenu 
onready var volumeSprite = $InitialMenu/VolumeSprite
onready var versionLabel = $InitialMenu/VersionLabel
onready var titleLabel = $InitialMenu/TitleLabel
onready var endlessModeBt = $InitialMenu/EndlessModeButton
onready var levelSelectButton = $InitialMenu/LevelSelectButton
onready var helpButton = $InitialMenu/HelpButton
onready var creditsButton = $InitialMenu/CreditsButton
onready var backButton = $BackButton
onready var fondo = $Fondo
onready var menuMusic = $MenuMusic
onready var initialMenu = $InitialMenu

var loaded = false
var cantStars  = []
var playing_music = true
var colorFontAct
var is_muted = false
var in_level_select_menu = false

#var nWorldAct


func _ready():
	get_tree().set_auto_accept_quit(false)
	randomize()
	init_volume()
	menuMusic.play()
	versionLabel.set_text("Version " + str(GameGlobals.VERSION ) )
	
	hideLevelSelectMenu()
	generate_LSButtons()
	
	for button in get_tree().get_nodes_in_group("LSButtons"):
		button.connect("pressed", self, "_some_button_pressed", [button])

	fondo.show()
	#fondo.setStopMouse()
	if(!GameGlobals.isColorsLoaded()):
		cambiaColorFondoLetraRand()
		GameGlobals.setColorsLoaded(true)
	else:
		cambiaColorFondoLetraAct()
	
	if(GameGlobals.is_to_ls_menu()):
		_on_LevelSelectButton_pressed()
	
	coins_spawn_in_main_menu()


func _on_MuteVolumeButton_pressed():
	if(is_muted):
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), false)
		is_muted = false
		volumeSprite.set_animation("unmuted")
	else:
		is_muted = true
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), true)
		volumeSprite.set_animation("muted")
	
	Persistance.update_is_muted(is_muted)

func init_volume():
	is_muted = !Persistance.load_is_muted()
	_on_MuteVolumeButton_pressed()


func generate_LSButtons():
	var lsBtAux
	
	for i in range(CANT_LS_BT_Y):
		for j in range(CANT_LS_BT_X):
			lsBtAux = LsButton.instance()
			lsBtAux.init_button(i * CANT_LS_BT_X + j + 1)
			lsBtAux.add_to_group("LSButtons")
			lsBtAux.set_position(Vector2(INI_X_LS_BT + INC_X_LS_BT * j, INI_Y_LS_BT + INC_Y_LS_BT * i) )
			lsBtAux.set_size(Vector2(170,100))
			levelSelectMenu.add_child(lsBtAux)

func cambiaColorFondoLetraAct():
	$Fondo.setColorDirecto(GameGlobals.getCurrentColor())
	changeFontColor(GameGlobals.getCurrentColorComp())

func cambiaColorFondoLetraRand():
	fondo.setColorFondo(1 + randi() % (GameGlobals.CANT_LEVELS - 1) )
	changeFontColor(fondo.getColorComplementario())
	GameGlobals.setCurrentColor(fondo.getColor())

func changeFontColor(color):
	colorFontAct = color
	var colorInv = Color((1 - color.r)/1.5, (1 - color.g)/1.5, (1 - color.b)/1.5)
	
	for button in get_tree().get_nodes_in_group("LSButtons"):
		button.add_color_override("font_color",color)
	titleLabel.add_color_override("font_color",color)
	endlessModeBt.add_color_override("font_color",color)
	$InitialMenu/EndlessModeButton/Filling.set_modulate(colorInv)
	$InitialMenu/EndlessModeButton/Borders.set_modulate(color)
	volumeSprite.set_modulate(color)
	$InitialMenu/LevelSelectButton/Filling.set_modulate(colorInv)
	$InitialMenu/LevelSelectButton/Borders.set_modulate(color)
	helpButton.add_color_override("font_color",color)
	$InitialMenu/HelpButton/Filling.set_modulate(colorInv)
	$InitialMenu/HelpButton/Borders.set_modulate(color)
	$InitialMenu/CreditsButton/Filling.set_modulate(colorInv)
	$InitialMenu/CreditsButton/Borders.set_modulate(color)
	versionLabel.add_color_override("font_color",color)
	$BackButton/ArrowSprite.set_modulate(color)


func _on_EndlessModeButton_mouse_enter():
	$InitialMenu/CreditsButton/Filling.set_modulate(Color(1,1,1))


func _on_EndlessModeButton_mouse_exit():
	$InitialMenu/CreditsButton/Filling.set_modulate(colorFontAct)


func _on_EndlessModeButton_focus_enter():
	$InitialMenu/CreditsButton/Filling.set_modulate(Color(1,1,1))




func _on_EndlessModeButton_focus_exit():
	$InitialMenu/CreditsButton/Filling.set_modulate(colorFontAct)


func _some_button_pressed(button):
    some_bt_pressed_automatically(button.getNumLevel())

func some_bt_pressed_automatically(nLevel):
	prepareLevelArcade(nLevel)

func prepareLevelArcade(nLevel):
	GameGlobals.set_level_act(nLevel)
	GameGlobals.set_game_mode_arcade()
	cambia_escena("res://GameScreenArcade.tscn")
    
    

func showLevelSelectMenu():
	
	if !loaded:
		cantStars  = Persistance.load_data_cantStars(1)
		for button in get_tree().get_nodes_in_group("LSButtons"): #disable a los que no se desbloquearon y enable a los que si
			if(button.getNumLevel() > 1):
				button.disable(cantStars[button.getNumLevel() - 2] == 0)
			if !button.is_disabled():
				button.update_stars_cant(cantStars[button.getNumLevel() - 1])
				button.show_stars()
			
		loaded = true
	
	
	levelSelectMenu.show()
	


func showInitialMenu():
	initialMenu.show()
	fondo.show()
	if !playing_music:
		menuMusic.play()
		playing_music = true

func hideInitialMenu():
	initialMenu.hide()

func hideLevelSelectMenu():
	levelSelectMenu.hide()
	backButton.hide()
   

func _on_HelpButton_pressed():
	cambia_escena("res://HelpMenu.tscn")


func _on_LevelSelectButton_pressed():
	in_level_select_menu = true
	hideInitialMenu() 
	showLevelSelectMenu()
	backButton.show()
    

func _on_CreditsButton_pressed():
	cambia_escena("res://Credits.tscn")

func cambia_escena(scenePath):
	menuMusic.stop()
	get_tree().change_scene(scenePath)


func _on_EndlessModeButton_pressed():
	GameGlobals.set_game_mode_endless()
	cambia_escena("res://GameScreenEndless.tscn")

func _on_BackButton_pressed():
	in_level_select_menu = false
	hideLevelSelectMenu()
	showInitialMenu()


func coins_spawn_in_main_menu():
	$CoinsInMainMenuTimer.start()
	
	coin_spawn_in_main_menu() #lanzo el primer coin

func coin_spawn_in_main_menu():
	var coin = Coin.instance()
	add_child(coin)
	
	coin.setUpForMainMenu()
	coin.dropFromAboveRand()
	



func _notification(notif):
	if notif == MainLoop.NOTIFICATION_WM_QUIT_REQUEST || notif == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST:
		if(in_level_select_menu):
			_on_BackButton_pressed()
		else:
			get_tree().quit()








