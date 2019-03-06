extends Node


const BASE_COIN_TIMER_WT = 1
const COIN_TIMER_WT_DEC_RATE = 0.45 / (24 - 1)
#Es cant a decrementar / (cantNiveles - 1)

const BASE_MIN_HAD_PU_WT = 10
const MIN_HAD_PU_TIMER_WT_INC_RATE = float(10) / (24 - 1)

const BASE_HAD_PU_WT_AMP = 3
const HAD_PU_TIMER_WT_AMP_INC_RATE = float(3) / (24 - 1)

const BASE_MIN_COIN_SPEED = 200
const COIN_MIN_SPEED_INC_RATE = float(100) / (24 - 1)

const BASE_COIN_SPEED_AMP = 25
const COIN_SPEED_AMP_INC_RATE = float(25) / (24 - 1)

const HELP_COIN_SPEED = 300
const CREDITS_COIN_SPEED = 500

const DEFAULT_CANT_LIVES_EM = 3

const X_INI_ZONA_TRIGGER_FP = -132
const Y_INI_ZONA_TRIGGER_FP = 1384.5

var SCREEN_WIDTH = Globals.get("display/width") #viewport.get_width()
var SCREEN_HEIGHT = Globals.get("display/height")
var SCREEN_WIDTH_FIX = SCREEN_WIDTH - CoinGlobals.COIN_WIDHT
#es var porque se calcula en tiempo de ejecucion pero deberia ser const

export (PackedScene) var Coin
export (PackedScene) var ZonaNoTocable
export (PackedScene) var ZonaTriggerFP #Fuera de la pantalla

var zonaNoTocableAct 
var zonaTriggerFPAct

var score = 0
var playtime
var levelAct

var timeInEndless = 0
var lives = DEFAULT_CANT_LIVES_EM
var colorLevel

var minCoinSpeed
var maxCoinSpeed

var minHad_PU_WT
var had_PU_WT_Amp


func _ready():
	
	get_tree().set_auto_accept_quit(false) #it prevents game closing when back bt is pressed
	randomize()
	coins_spawn_in_main_menu()

func stop_coin_spawn():
    get_node("CoinTimer").stop()

func new_game():
	playtime = QPFGlobals.BASE_GAME_TIME
	score = 0
	update_CoinSpeeds(levelAct)         #las ajusta al nivel seleccionado
	update_Had_PU_Speeds(levelAct)
	update_Prob_Flip_CPU(levelAct)
	get_node("HadamardPowUp").update_Speeds(levelAct)
	get_node("HUD").cambiaColorLevel(levelAct)
	get_node("CoinTimer").set_wait_time(BASE_COIN_TIMER_WT - COIN_TIMER_WT_DEC_RATE * (levelAct - 1) )
	get_node("StartTimer").start()
	
	creaZonaNoTocable()
	creaZonaTriggerFPLevel()
	
	var cantMinCoins = (playtime - (SCREEN_HEIGHT / ((minCoinSpeed + maxCoinSpeed) / 2 ) ) ) / get_node("CoinTimer").get_wait_time()
	get_node("HUD").prep_game(0,"Get Ready",QPFGlobals.BASE_GAME_TIME,int(cantMinCoins * 0.6 + 0.5) ,int(cantMinCoins * 0.75 + 0.5), int(cantMinCoins * 0.9 + 0.5) )


func new_game_endless():
	timeInEndless = 0
	lives = DEFAULT_CANT_LIVES_EM
	levelAct = 1
	colorLevel = 1
	update_level_data()
	get_node("EndlessModeStartTimer").start()
	get_node("HUD").cambiaColorLevel(float(1) / 16)
	creaZonaNoTocable()
	creaZonaTriggerFPEndless()
	
	get_node("HUD").prep_endless_game(0,"Get Ready", DEFAULT_CANT_LIVES_EM)
	#cambiar 1s por levelAct desp

func update_level_data():
	
	if(levelAct > QPFGlobals.CANT_LEVELS * float(3) / 4):
		zonaNoTocableAct.moverse()
	
	update_CoinSpeeds(levelAct)         #las ajusta al nivel seleccionado
	update_Had_PU_Speeds(levelAct)
	update_Prob_Flip_CPU(levelAct)
	get_node("HadamardPowUp").update_Speeds(levelAct)
	get_node("CoinTimer").set_wait_time(BASE_COIN_TIMER_WT - COIN_TIMER_WT_DEC_RATE * (levelAct - 1) )


func creaZonaNoTocable():
	zonaNoTocableAct = ZonaNoTocable.instance()
	add_child(zonaNoTocableAct)
	zonaNoTocableAct.appear()

func creaZonaTriggerFPLevel():
	zonaTriggerFPAct = ZonaTriggerFP.instance()
	add_child(zonaTriggerFPAct)
	zonaTriggerFPAct.connect("body_enter", self, "coinEnZonaTriggerFPLevel")
	zonaTriggerFPAct.set_pos(Vector2(X_INI_ZONA_TRIGGER_FP, Y_INI_ZONA_TRIGGER_FP))

func creaZonaTriggerFPEndless():
	zonaTriggerFPAct = ZonaTriggerFP.instance()
	add_child(zonaTriggerFPAct)
	zonaTriggerFPAct.connect("body_enter", self, "coinEnZonaTriggerFPEndless")
	zonaTriggerFPAct.set_pos(Vector2(X_INI_ZONA_TRIGGER_FP, Y_INI_ZONA_TRIGGER_FP))


func update_Prob_Flip_CPU(level):
	CoinGlobals.updateProbFlipCPU(level)

func _on_CoinTimer_timeout():
    var coin = Coin.instance()
    add_child(coin)
    coin.setMinMaxSpeed( minCoinSpeed, maxCoinSpeed )
    dropObjFromAboveRand(coin)

func coinEnZonaTriggerFPLevel(coin):
	if(coin.state == 1):
		scores()
	else: #(coin.state == 0)
		decrease_score()

func coinEnZonaTriggerFPEndless(coin):
	if(coin.state == 0):
		coin.remove_from_group("Coins") #para que el ultimo sobreviva y haga el sonido
		pierdeVidaEndless()
		coin.live_losed_sound()
		print("pierdeVida " + str(lives))

func scores():
    score += 1
    get_node("HUD").update_score(score)

func decrease_score():
	if score > 0:
		score -= 1
		get_node("HUD").update_score(score)

func _on_StartTimer_timeout():
	get_node("CoinTimer").start()
	get_node("GameEndingTimer").start()
	update_Had_PU_WT()
	get_node("HadPowUpTimer").set_wait_time( minHad_PU_WT  + randi() % int(had_PU_WT_Amp) )
	get_node("HadPowUpTimer").start()
	QPFGlobals.setLevel_starting(false)

func _on_EndlessModeStartTimer_timeout():
	get_node("CoinTimer").start()
	get_node("TimeScoreTimer").start()
	update_Had_PU_WT()
	get_node("HadPowUpTimer").set_wait_time( minHad_PU_WT  + randi() % int(had_PU_WT_Amp) )
	get_node("HadPowUpTimer").start()
	get_node("EndlessLevelAdvanceTimer").start()
	get_node("ColorChangerTimer").start()
	QPFGlobals.setLevel_starting(false)

func _on_EndlessLevelAdvanceTimer_timeout():
	if(levelAct < QPFGlobals.CANT_LEVELS_ENDLESS):
		levelAct += 1
	else: #(levelAct == QPFGlobals.CANT_LEVELS_ENDLESS)
		get_node("EndlessLevelAdvanceTimer").stop()
	
	update_level_data()
	print("level act = " + str(levelAct)  + "\n")

func _on_ColorChangerTimer_timeout():
	colorLevel += 1
	get_node("HUD").cambiaColorLevel(float(colorLevel) / 16)


func _on_TimeScoreTimer_timeout():
	timeInEndless += 1
	get_node("HUD").update_endless_score(timeInEndless)

func update_CoinSpeeds(level):
    minCoinSpeed = BASE_MIN_COIN_SPEED + COIN_MIN_SPEED_INC_RATE * (level - 1)
    maxCoinSpeed = minCoinSpeed + BASE_COIN_SPEED_AMP + COIN_SPEED_AMP_INC_RATE * (level - 1)
    #maxCoinSpeed = minCoinSpedd + speedAmplitude

func update_Had_PU_Speeds(level):
    get_node("HadamardPowUp").update_Speeds(level)

func update_Had_PU_WT():
    minHad_PU_WT = BASE_MIN_HAD_PU_WT + MIN_HAD_PU_TIMER_WT_INC_RATE * (levelAct - 1)
    had_PU_WT_Amp = BASE_HAD_PU_WT_AMP + HAD_PU_TIMER_WT_AMP_INC_RATE * (levelAct - 1)


func _on_HadPowUpTimer_timeout():
    get_node("HadPowUpTimer").set_wait_time( minHad_PU_WT + (randi() % int(had_PU_WT_Amp)) )
    dropObjFromAboveRand(get_node("HadamardPowUp") )

func coin_spawn_in_main_menu():
    var coin = Coin.instance()
    get_node("MainMenu").get_node("InitialMenu").add_child(coin)
    coin.setMinMaxSpeed( minCoinSpeed, maxCoinSpeed )
    if (randi() % 2) == 1:
        coin.activateHBuff()
    dropObjFromAboveRand(coin)


#Pre: rigidBody2D debe ser RigidBody2D y tener los atributos min_speed y max_speed definidos
func dropObjFromAbove(rigidBody2D, pathOffset, direction):
    
    get_node("CoinPath/CoinSpawnLocation").set_offset(pathOffset)
    rigidBody2D.set_pos(get_node("CoinPath/CoinSpawnLocation").get_pos())

    rigidBody2D.set_rot(direction)
    
    # Choose the velocity.

    rigidBody2D.set_linear_velocity(Vector2(rand_range(rigidBody2D.min_speed, rigidBody2D.max_speed), 0).rotated(direction))
    rigidBody2D.show()


#Pre: rigidBody2D debe ser RigidBody2D y tener los atributos min_speed y max_speed definidos
func dropObjFromAboveRand(rigidBody2D):

    var randOffset
    #SCREEN_WIDTH - 100 = 620 de ancho de pantalla efectiva
    randOffset = CoinGlobals.COIN_WIDHT / 2 + randi() % int(SCREEN_WIDTH_FIX + 1) 
    

    var randOffsetCmp = randOffset - CoinGlobals.COIN_WIDHT / 2
    # Set the pow up's direction perpendicular to the path direction.
    var direction = 0
    #from the top clockwise --> default rot angle is 0
    
    if randOffsetCmp < SCREEN_WIDTH_FIX * 0.2: #1/5 de pantalla
        direction += rand_range(-PI* 0.5, -PI * 0.375)
    elif randOffsetCmp < SCREEN_WIDTH_FIX * 0.4: #2/5 de pantalla
        direction += rand_range(-PI* 0.53, -PI * 0.41)
    elif randOffsetCmp < SCREEN_WIDTH_FIX * 0.6: #3/5 de pantalla
        direction += rand_range(-PI* 0.565, -PI * 0.435)
    elif randOffsetCmp < SCREEN_WIDTH_FIX * 0.8: #3/5 de pantalla
        direction += rand_range(-PI* 0.595, -PI* 0.47)
    else: #5/5 de pantalla
        direction += rand_range(-PI* 0.625, -PI * 0.5)

    dropObjFromAbove(rigidBody2D, randOffset, direction)

func dropObjFromAboveCentered(rigidBody2D):
	dropObjFromAbove(rigidBody2D, CoinGlobals.COIN_WIDHT / 2 + SCREEN_WIDTH_FIX / 2 , - PI / 2)

func _on_GameEndingTimer_timeout():
	playtime -= 1
	get_node("HUD").update_playtime(playtime)
	if playtime == 0:
		game_over()

func game_over():
	_on_HUD_stop_game() #aca se borra la zona no tocable
	get_node("HUD").show_game_over(1,levelAct,score)


func game_over_endless():
	_on_HUD_stop_game_endless()
	get_node("HUD").show_game_over_endless(timeInEndless)

func borraZonaNoTocable():
	if(zonaNoTocableAct != null):
		remove_child(zonaNoTocableAct)
		zonaNoTocableAct.queue_free() #also removes connected signals
		zonaNoTocableAct = null

func borraZonaTriggerFP():
	if(zonaTriggerFPAct != null):
		remove_child(zonaTriggerFPAct)
		zonaTriggerFPAct.queue_free()
		zonaTriggerFPAct = null



func _on_MainMenu_level_selected( nLevel ):
    levelAct = nLevel
    print("level act = " + str(nLevel))
    get_node("HUD").showHUD(1,nLevel)
    


func _on_HUD_back_to_level_select_menu():
    get_node("MainMenu").cambiaColorFondoLetra()
    get_node("MainMenu").showInitialMenu()
    get_node("MainMenu")._on_LevelSelectButton_pressed()
    

func _on_HUD_back_to_main_menu():
    get_node("MainMenu").cambiaColorFondoLetra()
    get_node("MainMenu").showInitialMenu()
    


func _on_HUD_stop_game():
	borraZonaNoTocable()
	borraZonaTriggerFP()
	get_node("StartTimer").stop()
	get_node("CoinTimer").stop()
	get_node("HadPowUpTimer").stop()
	get_node("GameEndingTimer").stop()
	for coin in get_tree().get_nodes_in_group("Coins"):
		coin.queue_free()
	get_node("HadamardPowUp").init()


func _on_HUD_stop_game_endless():
	borraZonaNoTocable()
	borraZonaTriggerFP()
	get_node("TimeScoreTimer").stop()
	get_node("EndlessLevelAdvanceTimer").stop()
	get_node("ColorChangerTimer").stop()
	get_node("EndlessModeStartTimer").stop()
	get_node("CoinTimer").stop()
	get_node("HadPowUpTimer").stop()
	for coin in get_tree().get_nodes_in_group("Coins"):
		coin.queue_free()
	get_node("HadamardPowUp").init()


func _on_HUD_next_level():
	get_node("MainMenu").some_bt_pressed_automatically(levelAct + 1)

func _notification(notif):
	if notif == MainLoop.NOTIFICATION_WM_QUIT_REQUEST: # || notif == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST: in Godot 3.0
		if QPFGlobals.actual_screen == QPFGlobals.SCREEN_TYPES.INITIAL_MENU:
			get_tree().quit()
		elif QPFGlobals.actual_screen == QPFGlobals.SCREEN_TYPES.IN_GAME:
			if QPFGlobals.isLevel_Starting() || QPFGlobals.isPaused():
				get_node("HUD")._on_MainMenuButton_pressed()
				get_node("MainMenu")._on_LevelSelectButton_pressed()
			else:
				get_node("HUD")._on_PauseButton_pressed()
		elif QPFGlobals.actual_screen == QPFGlobals.SCREEN_TYPES.LEVEL_SELECT:
			get_node("MainMenu")._on_BackButton_pressed()
		elif QPFGlobals.actual_screen == QPFGlobals.HELP:
			get_node("MainMenu")._on_BackButton_pressed()
			stop_coin_spawn_in_Help_Menu()
		elif QPFGlobals.actual_screen == QPFGlobals.CREDITS:
			get_node("MainMenu")._on_BackButton_pressed()
			stop_coin_spawn_in_Credits()
		elif(QPFGlobals.actual_screen == QPFGlobals.GAME_ENDED):
			get_node("HUD")._on_MainMenuButton_pressed()
			get_node("MainMenu")._on_LevelSelectButton_pressed()
		elif(QPFGlobals.actual_screen == QPFGlobals.GAME_ENDING):
			pass
		elif(QPFGlobals.actual_screen == QPFGlobals.ENDLESS_MODE):
			if QPFGlobals.isLevel_Starting() || QPFGlobals.isPaused():
				get_node("HUD")._on_MainMenuButton_pressed()
			else:
				get_node("HUD")._on_PauseButton_pressed()
		elif(QPFGlobals.actual_screen == QPFGlobals.GAME_ENDED_ENDLESS):
			get_node("HUD")._on_MainMenuButton_pressed()
		elif(QPFGlobals.actual_screen == QPFGlobals.GAME_ENDING_ENDLESS):
			pass

func activateHadPU():
	zonaNoTocableAct.activateHadamard()

func _on_CoinsInMenuTimer_timeout():
	coin_spawn_in_main_menu()


func stop_coin_spawn_in_menu():
	get_node("CoinsInMenuTimer").stop()
	for coin in get_tree().get_nodes_in_group("Coins"):
		coin.queue_free()

func coins_spawn_in_main_menu():
	levelAct = int(QPFGlobals.CANT_LEVELS / 2 + 0.5)
	update_CoinSpeeds(levelAct)         #las ajusta al nivel seleccionado
	CoinGlobals.setProbFlipCPU(0)
	get_node("CoinsInMenuTimer").start()


func coins_spawn_in_Help_Menu():
	stop_coin_spawn_in_menu()
	stop_coin_spawn_in_Help_Menu()
	CoinGlobals.reset_help_tips()
	
	
	levelAct = int(QPFGlobals.CANT_LEVELS / 4 + 0.5)
	update_CoinSpeeds(levelAct)         #las ajusta al nivel seleccionado
	CoinGlobals.setProbFlipCPU(0)
	get_node("CoinsInHMenuTimer").start()
	
	get_node("MainMenu").get_node("HelpMenu").updateMessages() #cambia los mensajes de los tips
	
	coin_spawn_in_Help_Menu() #lanzo el primer coin

func stop_coin_spawn_in_Help_Menu():
	get_node("CoinsInHMenuTimer").stop()
	for coin in get_tree().get_nodes_in_group("Coins"):
		coin.queue_free()



func _on_CoinsInHMenuTimer_timeout():
	coin_spawn_in_Help_Menu()


func coin_spawn_in_Help_Menu():
	var coin = Coin.instance()
	get_node("MainMenu").get_node("HelpMenu").add_child(coin)
	get_node("MainMenu").get_node("HelpMenu").activateCondition()
	CoinGlobals.setup_help_coin(coin)
	
	coin.setMinMaxSpeed(HELP_COIN_SPEED, 0)
	dropObjFromAboveCentered(coin)


func _on_MainMenu_change_help_tip():
	stop_coin_spawn_in_Help_Menu()
	
	get_node("MainMenu").get_node("HelpMenu").updateMessages() #cambia los mensajes de los tips
	
	get_node("CoinsInHMenuTimer").start()
	
	coin_spawn_in_Help_Menu() #lanzo el primer coin

func coins_spawn_in_credits():
	stop_coin_spawn_in_menu()
	CoinGlobals.initCreditsCoinTypes()
	
	levelAct = int(QPFGlobals.CANT_LEVELS / 4 + 0.5)
	update_CoinSpeeds(levelAct)         #las ajusta al nivel seleccionado
	CoinGlobals.setProbFlipCPU(0)
	get_node("CoinsInCreditsTimer").start()
	
	coin_spawn_in_credits() #lanzo el primer coin

func coin_spawn_in_credits():
	var coin = Coin.instance()
	get_node("MainMenu").get_node("Credits").add_child(coin)
	
	coin.setMinMaxSpeed(CREDITS_COIN_SPEED, 0)
	dropObjFromAboveCentered(coin)
	
	CoinGlobals.setup_credits_coin(coin)

func stop_coin_spawn_in_Credits():
	get_node("CoinsInCreditsTimer").stop()
	for coin in get_tree().get_nodes_in_group("Coins"):
		coin.queue_free()

func prep_endless_mode():
	stop_coin_spawn_in_menu()
	levelAct = 1
	print("level act = " + str(1))
	get_node("HUD").showHudEndlessMode()

func pierdeVidaEndless():
	lives -= 1
	if(lives == 0):
		game_over_endless() 
	get_node("HUD").update_endless_lives(lives)


#TODO

#General

#mundo 2 con pelotas de distinto tamaño
#mundo 3 con pelotas que desaparezcan y aparezcan
#endless mode con zona prohibida que se mueva





















