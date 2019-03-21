signal level_selected
signal to_help
signal to_level_select
signal to_main_menu
signal to_credits
signal change_help_tip
signal to_endless_mode

extends Control

export (PackedScene) var Lsbutton

const INI_X_LS_BT = 40
const INC_X_LS_BT = 235
const INI_Y_LS_BT = 50
const INC_Y_LS_BT = 130

const CANT_LS_BT_Y = 8
const CANT_LS_BT_X = 3


var loaded = false
var cantStars  = []
var playing_music = true
var colorFontAct
var is_muted = false
var cant_volume = 1.0 # in range [0,1]
var cant_volume_pre_muted = 0

var nWorldAct


func _ready():
   randomize()
   init_volume()
   get_node("MenuMusic").play()
   get_node("MenuMusic").set_loop(true)
   get_node("BackButton").hide()
   get_node("Credits").hide()
   get_node("InitialMenu/VersionLabel").set_text("Version " + str(QPFGlobals.VERSION ) )

   get_node("LevelSelectMenu").hide()
   generate_LSButtons()
   for button in get_tree().get_nodes_in_group("LSButtons"):
       button.connect("pressed", self, "_some_button_pressed", [button])

   get_node("Fondo").show()

   get_node("Fondo").setIgnoreMouse(false)
   get_node("Fondo").setStopMouse(true)
   cambiaColorFondoLetra()

func init_volume():
	get_node("InitialMenu/MuteVolumeButton/VolumeSlider").set_value(Persistance.load_last_volume())

func _on_MuteVolumeButton_pressed():
	if(is_muted):
		if(cant_volume_pre_muted == 0):
			cant_volume_pre_muted = 25
		get_node("InitialMenu/MuteVolumeButton/VolumeSlider").set_value(cant_volume_pre_muted)
		_on_VolumeSlider_value_changed( cant_volume_pre_muted )
		is_muted = false
		
	else:
		cant_volume_pre_muted = AudioServer.get_stream_global_volume_scale() * 100
		is_muted = true
		get_node("InitialMenu/MuteVolumeButton/VolumeSprite").set_animation("muted")
		get_node("InitialMenu/MuteVolumeButton/VolumeSlider").set_value(0)
		

func _on_VolumeSlider_value_changed( value ):
	#get_node("InitialMenu/MuteVolumeButton/VolumeSlider").hide()
	cant_volume = float(value) / 100
	AudioServer.set_stream_global_volume_scale(cant_volume)
	
	Persistance.update_last_volume(value)
	
	if(value == 0):
		is_muted = true
		get_node("InitialMenu/MuteVolumeButton/VolumeSprite").set_animation("muted")
	elif(value <= 33):
		get_node("InitialMenu/MuteVolumeButton/VolumeSprite").set_animation("volume_level_1")
	elif(value <= 66):
		get_node("InitialMenu/MuteVolumeButton/VolumeSprite").set_animation("volume_level_2")
	elif(value <= 100):
		get_node("InitialMenu/MuteVolumeButton/VolumeSprite").set_animation("full_volume")


func generate_LSButtons():
    var lsBtAux
    var levelSelecMenu = get_node("LevelSelectMenu")

    for i in range(CANT_LS_BT_Y):
        for j in range(CANT_LS_BT_X):
            lsBtAux = Lsbutton.instance()
            lsBtAux.init_button(i * CANT_LS_BT_X + j + 1)
            lsBtAux.add_to_group("LSButtons")
            lsBtAux.set_pos(Vector2(INI_X_LS_BT + INC_X_LS_BT * j, INI_Y_LS_BT + INC_Y_LS_BT * i) )
            lsBtAux.set_size(Vector2(170,100))
            levelSelecMenu.add_child(lsBtAux)

func cambiaColorFondoLetra():
	get_node("Fondo").setColorFondo(1 + randi() % (QPFGlobals.CANT_LEVELS - 1) )
	changeFontColor(get_node("Fondo").getColorComplementario())

func changeFontColor(color):
	colorFontAct = color
	
	for button in get_tree().get_nodes_in_group("LSButtons"):
		button.add_color_override("font_color",color)
	get_node("InitialMenu/TitleLabel").add_color_override("font_color",color)
	get_node("InitialMenu/EndlessModeButton").add_color_override("font_color",color)
	get_node("InitialMenu/EndlessModeButton/InfinitySprite").set_modulate(color)
	get_node("InitialMenu/MuteVolumeButton/VolumeSprite").set_modulate(color)
	get_node("InitialMenu/LevelSelectButton").add_color_override("font_color",color)
	get_node("InitialMenu/HelpButton").add_color_override("font_color",color)
	get_node("InitialMenu/ExitButton").add_color_override("font_color",color)
	get_node("InitialMenu/CreditsButton").add_color_override("font_color",color)
	get_node("InitialMenu/VersionLabel").add_color_override("font_color",color)
	get_node("BackButton").add_color_override("font_color",color)
	get_node("HelpMenu").changeFontColor(color)
	get_node("Credits").changeFontColor(color)


func _on_EndlessModeButton_mouse_enter():
	get_node("InitialMenu/EndlessModeButton/InfinitySprite").set_modulate(Color(1,1,1))


func _on_EndlessModeButton_mouse_exit():
	get_node("InitialMenu/EndlessModeButton/InfinitySprite").set_modulate(colorFontAct)


func _on_EndlessModeButton_focus_enter():
	get_node("InitialMenu/EndlessModeButton/InfinitySprite").set_modulate(Color(1,1,1))




func _on_EndlessModeButton_focus_exit():
	get_node("InitialMenu/EndlessModeButton/InfinitySprite").set_modulate(colorFontAct)


func _some_button_pressed(button):
    some_bt_pressed_automatically(button.getNumLevel())

func some_bt_pressed_automatically(nLevel):
    playing_music = false
    get_node("MenuMusic").stop()
    QPFGlobals.set_actual_screen(QPFGlobals.SCREEN_TYPES.IN_GAME)
    loaded = false
    hideLevelSelectMenu()
    get_node("BackButton").hide()
    emit_signal("level_selected",nLevel)


func _on_ExitButton_pressed():
    get_tree().quit()

func _on_BackButton_pressed():
    get_node("BackButton").hide()
    
    if QPFGlobals.actual_screen == QPFGlobals.HELP:
        get_node("HelpMenu").disappear()
    elif (QPFGlobals.actual_screen == QPFGlobals.CREDITS):
        hideCredits()
    else:
        hideLevelSelectMenu()

    QPFGlobals.set_actual_screen(QPFGlobals.SCREEN_TYPES.INITIAL_MENU)
    showInitialMenu()
    emit_signal("to_main_menu")

func showInitialMenu():
    get_node("InitialMenu").show()
    get_node("Fondo").show()
    if !playing_music:
        get_node("MenuMusic").play()
        playing_music = true

func hideInitialMenu():
    get_node("InitialMenu").hide()
    
    

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
   get_node("LevelSelectMenu").show()

func hideLevelSelectMenu():
   get_node("LevelSelectMenu").hide()
   get_node("Fondo").hide()
   

func _on_HelpButton_pressed():
    QPFGlobals.set_actual_screen(QPFGlobals.SCREEN_TYPES.HELP)
    hideInitialMenu()
    get_node("HelpMenu").appear()
    get_node("BackButton").show()
    emit_signal("to_help")  


func _on_LevelSelectButton_pressed():
    QPFGlobals.set_actual_screen(QPFGlobals.SCREEN_TYPES.LEVEL_SELECT)
    hideInitialMenu() 
    showLevelSelectMenu()
    get_node("BackButton").show()
    emit_signal("to_level_select")
    

func _on_CreditsButton_pressed():
	QPFGlobals.set_actual_screen(QPFGlobals.SCREEN_TYPES.CREDITS)
	hideInitialMenu() 
	showCredits()
	get_node("BackButton").show()
	emit_signal("to_credits")

func showCredits():
	get_node("Credits").appear()
	get_node("MenuMusic").stop()

func hideCredits():
	get_node("Credits").disappear()
	get_node("MenuMusic").play()


func _on_HelpMenu_change_help_tip():
	emit_signal("change_help_tip")





func _on_EndlessModeButton_pressed():
	playing_music = false
	QPFGlobals.set_actual_screen(QPFGlobals.SCREEN_TYPES.ENDLESS_MODE)
	hideInitialMenu()
	get_node("Fondo").hide() 
	get_node("MenuMusic").stop()
	emit_signal("to_endless_mode")
	








