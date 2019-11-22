extends "GameScreen.gd"


onready var startTimer = $Timers/StartTimer #EM = endless mode
onready var levelAdvanceTimer = $Timers/LevelAdvanceTimer
onready var timeScoreTimer = $Timers/TimeScoreTimer
onready var colorChangeTimer = $Timers/ColorChangerTimer
onready var liveLosedSound = $LiveLosedSound

# Called when the node enters the scene tree for the first time.
func _ready():
	hud = $HUDEndless
	hud.showHud()




#<----------------------Admin modo endless----------------------

func prep_game():
	levelAct = 1
	print("level act = " + str(1))
	hud.showHud()


func _on_StartTimer_timeout():
	coinTimer.start()
	timeScoreTimer.start()
	update_Had_PU_WT()
	hadPUTimer.set_wait_time( minHad_PU_WT  + randi() % int(had_PU_WT_Amp) )
	hadPUTimer.start()
	levelAdvanceTimer.start()
	colorChangeTimer.start()
	GameGlobals.setLevel_starting(false)

func new_game():
	setGameScreen(GAME_SCREEN.IN_GAME)
	timeInEndless = 0
	lives = DEFAULT_CANT_LIVES_EM
	levelAct = 1
	colorLevel = 1
	update_level_data()
	startTimer.start()
	hud.cambiaColorLevel(float(1) / 16)
	creaZonaNoTocable()
	creaZonaTriggerFP()
	
	hud.prep_game(0,"Get Ready", DEFAULT_CANT_LIVES_EM)
	#cambiar 1s por levelAct desp

func update_level_data():
	
	if(levelAct > GameGlobals.CANT_LEVELS * float(3) / 4):
		zonaNoTocableAct.moverse()
	
	update_CoinSpeeds(levelAct)         #las ajusta al nivel seleccionado
	update_Had_PU_Speeds(levelAct)
	update_Prob_Flip_CPU(levelAct)
	hadamardPU.update_Speeds(levelAct)
	coinTimer.set_wait_time(BASE_COIN_TIMER_WT - COIN_TIMER_WT_DEC_RATE * (levelAct - 1) )


func creaZonaTriggerFP():
	zonaTriggerFPAct = ZonaTriggerFP.instance()
	add_child(zonaTriggerFPAct)
	zonaTriggerFPAct.connect("body_entered", self, "coinEnZonaTriggerFP")
	zonaTriggerFPAct.set_position(Vector2(X_INI_ZONA_TRIGGER_FP, Y_INI_ZONA_TRIGGER_FP))


func coinEnZonaTriggerFP(coin):
	if(coin.state == 0):
		#coin.remove_from_group("Coins") #para que el ultimo sobreviva y haga el sonido
		liveLosedSound.play()
		pierdeVida()
		print("pierdeVida " + str(lives))



func pierdeVida():
	lives -= 1
	if(lives == 0):
		game_over() 
	hud.update_lives(lives)


func game_over():
	_on_HUDEndless_stop_game()
	setGameScreen(GAME_SCREEN.GAME_ENDING)
	hud.show_game_over(timeInEndless)
	setGameScreen(GAME_SCREEN.GAME_ENDED)


func _on_HUDEndless_stop_game():
	timeScoreTimer.stop()
	levelAdvanceTimer.stop()
	colorChangeTimer.stop()
	startTimer.stop()
	coinTimer.stop()
	hadPUTimer.stop()
	coinGenerator.deactivate_active_coins()
	hadamardPU.to_out_screen_position() #desaparezco el PU antes que la zonaNoTocable
	borraZonaNoTocable()
	borraZonaTriggerFP()

func _on_LevelAdvanceTimer_timeout():
	if(levelAct < GameGlobals.CANT_LEVELS_ENDLESS):
		levelAct += 1
	else: #(levelAct == GameGlobals.CANT_LEVELS_ENDLESS)
		levelAdvanceTimer.stop()
	
	update_level_data()
	print("level act = " + str(levelAct)  + "\n")

func _on_TimeScoreTimer_timeout():
	timeInEndless += 1
	hud.update_score(timeInEndless)

func _on_ColorChangerTimer_timeout():
	colorLevel += 1
	hud.cambiaColorLevel(float(colorLevel) / 16)


func _notification(notif):
	if notif == MainLoop.NOTIFICATION_WM_QUIT_REQUEST || notif == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST: 
		if(game_screen == GAME_SCREEN.GAME_ENDED):
			goBackToMainMenu()
		elif(game_screen == GAME_SCREEN.IN_GAME):
			if(GameGlobals.isPaused()):
				goBackToMainMenu()
			else:
				pause()
		#elif(game_screen == GAME_SCREEN.GAME_ENDING):
		#	pass

#<----------------------Admin modo endless----------------------

