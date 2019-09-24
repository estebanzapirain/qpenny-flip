extends "GameScreen.gd"

onready var startTimer = $Timers/StartTimer
onready var GETimer = $Timers/GETimer





# Called when the node enters the scene tree for the first time.
func _ready():
	hud = $HUDArcade
	hud.showHUD(1,levelAct)



#<-----------------------Admin modo arcade----------------------



func new_game():
	setGameScreen(GAME_SCREEN.IN_GAME)
	playtime = GameGlobals.BASE_GAME_TIME
	score = 0
	update_CoinSpeeds(levelAct)         #las ajusta al nivel seleccionado
	update_Had_PU_Speeds(levelAct)
	update_Prob_Flip_CPU(levelAct)
	hadamardPU.update_Speeds(levelAct)
	hud.cambiaColorLevel(levelAct)
	coinTimer.set_wait_time(BASE_COIN_TIMER_WT - COIN_TIMER_WT_DEC_RATE * (levelAct - 1) )
	startTimer.start()
	
	creaZonaNoTocable()
	creaZonaTriggerFP()
	
	var cantMinCoins = (playtime - (GameGlobals.SCREEN_HEIGHT / ((minCoinSpeed + maxCoinSpeed) / 2 ) ) ) / coinTimer.get_wait_time()
	hud.prep_game(0,"Get Ready",GameGlobals.BASE_GAME_TIME,int(cantMinCoins * 0.6 + 0.5) ,int(cantMinCoins * 0.75 + 0.5), int(cantMinCoins * 0.9 + 0.5) )


func creaZonaTriggerFP():
	zonaTriggerFPAct = ZonaTriggerFP.instance()
	add_child(zonaTriggerFPAct)
	zonaTriggerFPAct.connect("body_entered", self, "coinEnZonaTriggerFP")
	zonaTriggerFPAct.set_position(Vector2(X_INI_ZONA_TRIGGER_FP, Y_INI_ZONA_TRIGGER_FP))



func coinEnZonaTriggerFP(coin):
	if(coin.state == 1):
		scores(coin.position)
	else: #(coin.state == 0)
		decrease_score(coin.position)


func scores(coinPos):
	score += 1
	hud.update_score(score)
	hud.creaScoreMessage(coinPos - Vector2(50, 150))

func decrease_score(coinPos):
	if score > 0:
		score -= 1
		hud.update_score(score)
	hud.creaDecreaseScoreMessage(coinPos - Vector2(50, 150))

func _on_StartTimer_timeout():
	coinTimer.start()
	GETimer.start()
	update_Had_PU_WT()
	hadPUTimer.set_wait_time( minHad_PU_WT  + randi() % int(had_PU_WT_Amp) )
	hadPUTimer.start()
	GameGlobals.setLevel_starting(false)


func _on_GETimer_timeout(): #game ending timer
	playtime -= 1
	hud.update_playtime(playtime)
	if playtime == 0:
		game_over()

func game_over():
	_on_HUDArcade_stop_game() #aca se borra la zona no tocable
	setGameScreen(GAME_SCREEN.GAME_ENDING)
	hud.show_game_over(1,levelAct,score)
	setGameScreen(GAME_SCREEN.GAME_ENDED)

func _on_MainMenu_level_selected( nLevel ):
	levelAct = nLevel
	print("level act = " + str(nLevel))
	hud.showHUD(1,nLevel)
	

func _on_HUDArcade_back_to_level_select_menu():
	GameGlobals.set_to_ls_menu(true)
	cambia_escena("res://MainMenu.tscn")
    

func _on_HUDArcade_stop_game():
	startTimer.stop()
	coinTimer.stop()
	hadPUTimer.stop()
	GETimer.stop()
	for coin in get_tree().get_nodes_in_group("Coins"):
		coin.queue_free()
	hadamardPU.init() #desaparezco el PU antes que la zonaNoTocable
	borraZonaNoTocable()
	borraZonaTriggerFP()


func goBackToLSMenu():
	hud.goBackToLSMenu()

func _on_HUDArcade_next_level():
	levelAct += 1
	hud.showHUD(1,levelAct)


func stop_coin_spawn():
	coinTimer.stop()

func _notification(notif):
	if notif == MainLoop.NOTIFICATION_WM_QUIT_REQUEST || notif == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST: 
		if(game_screen == GAME_SCREEN.GAME_ENDED):
			goBackToLSMenu()
		elif(game_screen == GAME_SCREEN.IN_GAME):
			if(GameGlobals.isPaused()):
				goBackToLSMenu()
			else:
				pause()
		#elif(game_screen == GAME_SCREEN.GAME_ENDING):
		#	pass
#<-----------------------Admin modo arcade----------------------


#_on_HUD_back_to_main_menu esta declarado en la clase padre

