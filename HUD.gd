signal back_to_main_menu

extends CanvasLayer


const INI_X_LS_BT = 40
const INC_X_LS_BT = 235
const INI_Y_LS_BT = 570
const INC_Y_LS_BT = 130

const POS_INI_LM_BUTTON = Vector2(341,921)
const POS_INI_MM_BUTTON = Vector2(341,1045)


onready var scoreLabel = $ScoreLabel
onready var highscoreLabel = $HighscoreLabel
onready var messageLabel = $MessageLabel
onready var gameTimerLabel = $GameTimerLabel
onready var pauseButton = $PauseButton
onready var pauseMenu = $PMLayer/PauseMenu
onready var PMTitleLabel = $PMLayer/PauseMenu/VBoxContainer/VBoxContainer2/TitleLabel
onready var PMStartButton = $PMLayer/PauseMenu/VBoxContainer/PMButtons/StartButton
onready var PMResumeButton = $PMLayer/PauseMenu/VBoxContainer/PMButtons/ResumeButton
onready var PMMainMenuButton = $PMLayer/PauseMenu/VBoxContainer/PMButtons/MainMenuButton
onready var fondo = $Fondo
onready var game_music = $Game_music
onready var messageTimer = $Timers/MessageTimer



var nWorldAct 



func _ready():
	pass

func setMessageFontColors(color): #r, g and b are values in [0;1] range
	scoreLabel.add_color_override("font_color",color)
	highscoreLabel.add_color_override("font_color",color)
	messageLabel.add_color_override("font_color",color)
	PMTitleLabel.add_color_override("font_color",color)
	PMStartButton.add_color_override("font_color",color)
	PMResumeButton.add_color_override("font_color",color)
	PMMainMenuButton.add_color_override("font_color",color)
	
	
	changePauseButtonColor( color )

func changePauseButtonColor( color ):
		pauseButton.changeColor(color) #change sprite color 
	 #to change properly must be originally white 
	 #also changes the child nodes color
	 #self_modulate is used to change only that node




func hideHUD():
	pauseMenu.hide()
	pauseButton.hide()
	highscoreLabel.hide()
	scoreLabel.hide()
	messageLabel.hide()
	gameTimerLabel.hide()
	fondo.hide()


func cambiaColorLevel(nLevel):
	var intNLevel = int(nLevel)
	var fracNLevel = nLevel - intNLevel
	fondo.setColorFondo(1 + fracNLevel + intNLevel % int(GameGlobals.CANT_LEVELS * float(5) / 4 )) #% GameGlobals.CANT_LEVELS)
	setMessageFontColors(fondo.getColorComplementario() )


func show_message(text):
	messageLabel.set_text(text)
	messageLabel.show()
	messageTimer.start()
   


func update_playtime(playtime):
	update_gameTimerLabel(playtime)

func update_gameTimerLabel(playtime):
	if(playtime < 10):
		gameTimerLabel.set_text("0" + str(playtime))
	else:
		gameTimerLabel.set_text(str(playtime))

func _on_MessageTimer_timeout():
	messageLabel.hide()


func _on_StartButton_pressed():
	GameGlobals.setLevel_starting(true)
	game_over()
	get_tree().set_pause(false)
	GameGlobals.setPaused(false)
	pauseMenu.hide()
	pauseButton.show()




func _on_MainMenuButton_pressed(): 
	goBackToMainMenu()

func goBackToMainMenu():
	get_tree().set_pause(false)
	emit_signal("back_to_main_menu")


func game_over():
	pass


func _on_PauseButton_pressed():
	pause()
    

func pause():
	game_music.stop()
	get_tree().set_pause(true)
	GameGlobals.setPaused(true)
	pauseButton.hide()  
	PMStartButton.set_text("Restart")  
	PMResumeButton.show()
	pauseMenu.show()
	fondo.setStopMouse()


func _on_ResumeButton_pressed():
	game_music.play()
	pauseMenu.hide()
	pauseButton.show()  
	get_tree().set_pause(false)
	fondo.setIgnoreMouse()
	GameGlobals.setPaused(false)
    
