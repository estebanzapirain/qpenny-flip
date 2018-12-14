signal level_selected
signal to_help
signal to_level_select
signal to_main_menu

extends Control

export (PackedScene) var Lsbutton

const INI_X_LS_BT = 40
const INC_X_LS_BT = 235
const INI_Y_LS_BT = 50
const INC_Y_LS_BT = 130

var cantLSBt = 1
var inHelpScreen = false
var loaded = false
var cantStars  = []
var playing_music = true

func _ready():
   get_node("MenuMusic").play()
   get_node("MenuMusic").set_loop(true)
   get_node("HelpSprite").hide()
   get_node("BackButton").hide()

   hideLevelSelectMenu()
   generate_LSButtons()
   for button in get_tree().get_nodes_in_group("LSButtons"):
       button.connect("pressed", self, "_some_button_pressed", [button])
   


func generate_LSButtons():
    var lsBtAux
    var levelSelecMenu = get_node("LevelSelectMenu")

    for i in range(8):
        for j in range(3):
            lsBtAux = Lsbutton.instance()
            lsBtAux.init_button(i * 3 + j + 1)
            lsBtAux.add_to_group("LSButtons")
            lsBtAux.set_pos(Vector2(INI_X_LS_BT + INC_X_LS_BT * j, INI_Y_LS_BT + INC_Y_LS_BT * i) )
            lsBtAux.set_size(Vector2(170,100))
            levelSelecMenu.add_child(lsBtAux)

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
    QPFGlobals.set_actual_screen(QPFGlobals.SCREEN_TYPES.INITIAL_MENU)
    get_node("BackButton").hide()
    
    if inHelpScreen:
        get_node("HelpSprite").hide()
        inHelpScreen = false
    else:
        hideLevelSelectMenu()

    showInitialMenu()
    emit_signal("to_main_menu")

func showInitialMenu():
    get_node("InitialMenu").show()
    if !playing_music:
        get_node("MenuMusic").play()
        playing_music = true

func hideInitialMenu():
    get_node("InitialMenu").hide()
    

func showLevelSelectMenu():
   if !loaded:
       cantStars  = Persistance.load_data_cantStars()
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

func _on_HelpButton_pressed():
    QPFGlobals.set_actual_screen(QPFGlobals.SCREEN_TYPES.HELP)
    hideInitialMenu()

    inHelpScreen = true
    var helpSprite = get_node("HelpSprite")
    helpSprite.set_pos(Vector2(361,637) )
    helpSprite.show()
    get_node("BackButton").show()
    emit_signal("to_help")
    
    


func _on_LevelSelectButton_pressed():
    QPFGlobals.set_actual_screen(QPFGlobals.SCREEN_TYPES.LEVEL_SELECT)
    hideInitialMenu() 
    showLevelSelectMenu()
    get_node("BackButton").show()
    emit_signal("to_level_select")
    


    





