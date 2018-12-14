extends Node


const BASE_COIN_TIMER_WT = 1
const COIN_TIMER_WT_DEC_RATE = 0.975

const BASE_MIN_HAD_PU_WT = 10
const MIN_HAD_PU_TIMER_WT_INC_RATE = 1.025

const BASE_HAD_PU_WT_AMP = 3
const HAD_PU_TIMER_WT_AMP_INC_RATE = 1.025

const BASE_MIN_COIN_SPEED = 200
const COIN_MIN_SPEED_INC_RATE = 1.025

const BASE_COIN_SPEED_AMP = 25
const COIN_SPEED_AMP_INC_RATE = 1.025

const BASE_MIN_CPU_TRY_WT = 1
const BASE_CPU_TRY_WT_AMP = 0.3
const CPU_TRY_WT_DEC_RATE = 0.975

var SCREEN_WIDTH = Globals.get("display/width") #viewport.get_width()
var SCREEN_HEIGHT = Globals.get("display/height")
#es var porque se calcula en tiempo de ejecucion pero deberia ser const

export (PackedScene) var Coin
export (PackedScene) var AreaNoTocable

var score = 0
var playtime
var levelAct

var minCoinSpeed
var maxCoinSpeed

var minHad_PU_WT
var had_PU_WT_Amp


func _ready():
	get_tree().set_auto_accept_quit(false) #it prevents game closing when back bt is pressed
	randomize()
	coins_spawn_in_main_menu()

func game_over():
    _on_HUD_stop_game()
    get_node("HUD").show_game_over(levelAct,score)

func stop_coin_spawn():
    get_node("CoinTimer").stop()

func new_game():
    playtime = QPFGlobals.BASE_GAME_TIME
    score = 0
    update_CoinSpeeds()         #las ajusta al nivel seleccionado
    update_Had_PU_Speeds()
    get_node("HadamardPowUp").update_Speeds(levelAct)
    update_CPU_Try_WT()
    get_node("CoinTimer").set_wait_time(BASE_COIN_TIMER_WT * pow(COIN_TIMER_WT_DEC_RATE,levelAct))
    get_node("StartTimer").start()

    var cantMinCoins = (playtime - (SCREEN_HEIGHT / ((minCoinSpeed + maxCoinSpeed) / 2 ) ) ) / get_node("CoinTimer").get_wait_time()
    get_node("HUD").prep_game(0,"Get Ready",QPFGlobals.BASE_GAME_TIME,int(cantMinCoins * 0.6 + 0.5) ,int(cantMinCoins * 0.75 + 0.5), int(cantMinCoins * 0.9 + 0.5) )


func _on_CoinTimer_timeout():
    var coin = Coin.instance()
    add_child(coin)
    coin.setMinMaxSpeed( minCoinSpeed, maxCoinSpeed )
    dropObjFromAbove(coin)

func update_CPU_Try_WT():  #Pre: it has to be called just after instancing a coin 
    CoinGlobals.setMin_CPU_Try_WT( BASE_MIN_CPU_TRY_WT * pow(CPU_TRY_WT_DEC_RATE,levelAct) )
    CoinGlobals.setMax_CPU_Try_WT( CoinGlobals.getMin_CPU_Try_WT() + BASE_CPU_TRY_WT_AMP * pow(CPU_TRY_WT_DEC_RATE,levelAct) )

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

func update_CoinSpeeds():
    minCoinSpeed = BASE_MIN_COIN_SPEED * pow(COIN_MIN_SPEED_INC_RATE,levelAct - 1)
    maxCoinSpeed = minCoinSpeed + BASE_COIN_SPEED_AMP * pow(COIN_SPEED_AMP_INC_RATE,levelAct - 1)
    #maxCoinSpeed = minCoinSpedd + speedAmplitude

func update_Had_PU_Speeds():
    get_node("HadamardPowUp").update_Speeds(levelAct)

func update_Had_PU_WT():
    minHad_PU_WT = BASE_MIN_HAD_PU_WT * pow(MIN_HAD_PU_TIMER_WT_INC_RATE,levelAct)
    had_PU_WT_Amp = HAD_PU_TIMER_WT_AMP_INC_RATE * pow(HAD_PU_TIMER_WT_AMP_INC_RATE,levelAct)


func _on_HadPowUpTimer_timeout():
    get_node("HadPowUpTimer").set_wait_time( minHad_PU_WT + (randi() % int(had_PU_WT_Amp)) )
    dropObjFromAbove(get_node("HadamardPowUp") )

func coin_spawn_in_main_menu():
    var coin = Coin.instance()
    get_node("MainMenu").get_node("InitialMenu").add_child(coin)
    coin.setMinMaxSpeed( minCoinSpeed, maxCoinSpeed )
    if (randi() % 2) == 1:
        coin.activateHBuff()
    dropObjFromAbove(coin)


#Pre: rigidBody2D debe ser RigidBody2D y tener los atributos min_speed y max_speed definidos
func dropObjFromAbove(rigidBody2D):
	
   # Choose a random location on Path2D.
    var randOffset
    var screenWidthFix = SCREEN_WIDTH - CoinGlobals.COIN_WIDHT
    #SCREEN_WIDTH - 100 = 620 de ancho de pantalla efectiva
    randOffset = CoinGlobals.COIN_WIDHT / 2 + randi() % int(screenWidthFix + 1) 
    #SCREEN_WIDTH / 4 + 
    get_node("CoinPath/CoinSpawnLocation").set_offset(randOffset)

    var randOffsetCmp = randOffset - CoinGlobals.COIN_WIDHT / 2
    # Set the pow up's direction perpendicular to the path direction.
    var direction = get_node("CoinPath/CoinSpawnLocation").get_rot()
    # Set the pow up's position to a random location.
    rigidBody2D.set_pos(get_node("CoinPath/CoinSpawnLocation").get_pos())
    # Add some randomness to the direction.
    
    if randOffsetCmp < screenWidthFix * 0.2: #1/5 de pantalla
        direction += rand_range(-PI* 0.5, -PI * 0.375)
    elif randOffsetCmp < screenWidthFix * 0.4: #2/5 de pantalla
        direction += rand_range(-PI* 0.53, -PI * 0.41)
    elif randOffsetCmp < screenWidthFix * 0.6: #3/5 de pantalla
        direction += rand_range(-PI* 0.565, -PI * 0.435)
    elif randOffsetCmp < screenWidthFix * 0.8: #3/5 de pantalla
        direction += rand_range(-PI* 0.595, -PI* 0.47)
    else: #5/5 de pantalla
        direction += rand_range(-PI* 0.625, -PI * 0.5)

    rigidBody2D.set_rot(direction)
    # Choose the velocity.
    rigidBody2D.set_linear_velocity(Vector2(rand_range(rigidBody2D.min_speed, rigidBody2D.max_speed), 0).rotated(direction))
    rigidBody2D.show()

func _on_GameEndingTimer_timeout():
    playtime -= 1
    get_node("HUD").update_playtime(playtime)
    if playtime == 0:
        game_over()



func _on_MainMenu_level_selected( nLevel ):
    levelAct = nLevel
    print("level act = " + str(nLevel))
    get_node("HUD").showHUD(nLevel)
    


func _on_HUD_back_to_menu():
    get_node("MainMenu").showInitialMenu()
    get_node("MainMenu")._on_LevelSelectButton_pressed()


func _on_HUD_stop_game():
    get_node("StartTimer").stop()
    get_node("CoinTimer").stop()
    get_node("HadPowUpTimer").stop()
    get_node("GameEndingTimer").stop()
    get_node("AreaNoTocable").disappear()
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
		else: # QPFGlobals.actual_screen == QPFGlobals.HELP:
			get_node("MainMenu")._on_BackButton_pressed()



func _on_CoinsInMenuTimer_timeout():
	coin_spawn_in_main_menu()


func stop_coin_spawn_in_menu():
	get_node("CoinsInMenuTimer").stop()
	for coin in get_tree().get_nodes_in_group("Coins"):
		coin.queue_free()

func coins_spawn_in_main_menu():
	levelAct = int(QPFGlobals.CANT_LEVELS / 2 + 0.5)
	update_CoinSpeeds()         #las ajusta al nivel seleccionado
	CoinGlobals.setMin_CPU_Try_WT(9999)
	CoinGlobals.setMax_CPU_Try_WT(9999)
	get_node("CoinsInMenuTimer").start()
