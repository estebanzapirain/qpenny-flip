extends Node2D

const OUT_SCREEN_POSITION = Vector2(-200,-200)
const CANT_COINS = 30

var Coin = load("res://Coin.tscn")

onready var coinSpawnLoc = $CoinPath/CoinSpawnLocation

var id_out_screen_coins = [] #it stores the out screen coins index
var cant_out_screen_coins = 0


#these two variables are meant to set the speed range for the coins
#appearing in GameScreen
var coinMinSpeed = 0 setget setCoinMinSpd,getCoinMinSpd
var coinMaxSpeed = 0 setget setCoinMaxSpd,getCoinMaxSpd


var coins = [] #all the avaliable coins

#---------------Class invariants---------------
# 0 <= cant_out_screen_coins <= MAX_CANT_COINS
#----------------------------------------------

#the coins will rotate between in screen and out screen states
#out_screen_coin: it wont move and will be in OUT_SREEN_POSITION
#in_screen_coin: it will be moving at a setted speed across the screen and
#it will change to the out screen state when leaving the screen

func _ready():
	_setup_coin_arrays()
	_create_coins()
#	dropCoinMainMenu()
#	yield(get_tree().create_timer(2),"timeout")
#	deactivate_active_coins()
	#-----------------------------------------------
	_checkInvariant()

func setCoinMinSpd(value:float)->void:
	coinMinSpeed = value

func getCoinMinSpd()->float:
	return coinMinSpeed 

func setCoinMaxSpd(value:float)->void:
	coinMaxSpeed = value

func getCoinMaxSpd()->float:
	return coinMaxSpeed 


#Pre:- coin has to be of Coin class
#    - coin != null
#    - coin.speed != null
#    - coin.speed > 0
#    - 50 <= pathOffset <= 670
#Post: the coin is dropped with the specified pathOffset and direction
func _dropCoinFromAbove(coin,pathOffset:float,direction:float) -> void:
	assert((50 <= pathOffset) and (pathOffset <= 670))
	assert(coin.speed != null)
	assert(coin.speed > 0)
	#-----------------------------------------------
	coin.setIn_screen(true)
	coin.setActive(true)
	_efectivelyDropDroppableFromAbove(coin,pathOffset,direction)

#Pre:- coin has to be of Droppable class
#    - coin != null
#    - coin.speed != null
#    - coin.speed > 0
#    - 50 <= pathOffset <= 670
#Post: the coin is dropped with the specified pathOffset and direction
func _efectivelyDropDroppableFromAbove(coin,pathOffset:float,direction:float) -> void:
	assert((50 <= pathOffset) and (pathOffset <= 670))
	assert(coin.speed != null) 
	assert(coin.speed > 0)
	#-----------------------------------------------
	coinSpawnLoc.set_offset(pathOffset)
	coin.dropFromAbove(coinSpawnLoc.get_position(),direction)

#Pre:- dropa has to be of Droppable class
#    - dropa != null
#    - dropa.speed != null
#    - dropa.speed > 0
#Post: the droppable will be dropped from a 
#random position in the range x e [49,671] and y e [-1,1]
#and a random direction depending on the postion seted in position
func _dropDroppableFromAboveRand(dropa) -> void:
	assert(dropa.speed != null) 
	assert(dropa.speed > 0)
	_checkInvariant()
	#-----------------------------------------------
	var randOffset = _random_offset_calculus()
	#normalized in [0,GameGlobals.SCREEN_WIDTH_FIX]
	var randOffsetCmp = _fixed_random_offset_calculus(randOffset)
	# Set the pow up's direction perpendicular to the path direction.
	
	var direction =  _random_direction_calculus(randOffsetCmp)
	#from the top clockwise --> default rot angle is 0
	
	
	_efectivelyDropDroppableFromAbove(dropa,randOffset,direction)

#Pre:- coin has to be of Droppable class
#    - coin != null
#    - coin.speed != null
#    - coin.speed > 0
#Post: the droppable will be dropped from a 
#random position in the range x e [49,671] and y e [-1,1]
#and a random direction depending on the postion seted in position
func _dropCoinFromAboveRand(coin) -> void:
	assert(coin.speed != null) 
	assert(coin.speed > 0)
	_checkInvariant()
	#-----------------------------------------------
	var randOffset = _random_offset_calculus()
	#normalized in [0,GameGlobals.SCREEN_WIDTH_FIX]
	var randOffsetCmp = _fixed_random_offset_calculus(randOffset)
	# Set the pow up's direction perpendicular to the path direction.
	
	var direction =  _random_direction_calculus(randOffsetCmp)
	#from the top clockwise --> default rot angle is 0
	
	
	_dropCoinFromAbove(coin,randOffset,direction)

func _random_offset_calculus()->float:
	#SCREEN_WIDTH - ancho de coin = 620 de ancho de pantalla efectiva
	var randOffset = float(CoinGlobals.COIN_WIDHT) / 2 + randi() % int(GameGlobals.SCREEN_WIDTH_FIX + 1) 
	return randOffset 

func _fixed_random_offset_calculus(randOffset)->float:
	#normalized in [0,GameGlobals.SCREEN_WIDTH_FIX]
	return randOffset - float(CoinGlobals.COIN_WIDHT) / 2

func _random_direction_calculus(offset:float)->float:
	var direction
	if offset < GameGlobals.SCREEN_WIDTH_FIX * 0.2: #1/5 de pantalla
		direction = rand_range(PI* 0.5, PI * 0.375)
	elif offset < GameGlobals.SCREEN_WIDTH_FIX * 0.4: #2/5 de pantalla
		direction = rand_range(PI* 0.53, PI * 0.41)
	elif offset < GameGlobals.SCREEN_WIDTH_FIX * 0.6: #3/5 de pantalla
		direction = rand_range(PI* 0.565, PI * 0.435)
	elif offset < GameGlobals.SCREEN_WIDTH_FIX * 0.8: #4/5 de pantalla
		direction = rand_range(PI* 0.595, PI* 0.47)
	else: #5/5 de pantalla
		direction = rand_range(PI* 0.625, PI * 0.5)
	
	return direction

func _dropCoinFromAboveCentered(coin):
	var offset = float(CoinGlobals.COIN_WIDHT) / 2 + GameGlobals.SCREEN_WIDTH_FIX / 2
	_dropCoinFromAbove(coin,offset,PI/2)


#Resizes the coins and id_out_screen_coins arrays with CANT_COINS elements
func _setup_coin_arrays():
	
	coins.resize(CANT_COINS)
	id_out_screen_coins.resize(CANT_COINS)
	
	#-----------------------------------------------
	_checkInvariant()

#Pre:this have to be called once and only the CoinGenerator is instanced
#Post: coins will be filled with CANT_COINS coins
func _create_coins():
	_checkInvariant()
	#-----------------------------------------------
	var coin = null
	for i in range(CANT_COINS):
		coin = Coin.instance()
		coin.set_position(OUT_SCREEN_POSITION)
		add_child(coin)
		coin.setId(i)
		coin.connect("out_of_view",self,"deactivate_out_screen_coin",[coin])
		coins[i] = coin
		deactivate_out_screen_coin(coin)


#Pre: cant_out_screen_coins > 0
#Post: a coin is pulled from out_screen_coins and is also returned
#      also the coin is added to the group active_coins
func _pullCoin():
	_checkInvariant()
	assert(cant_out_screen_coins > 0)
	#-----------------------------------------------
	cant_out_screen_coins -= 1
	print(cant_out_screen_coins)
	var id_coin = id_out_screen_coins[cant_out_screen_coins]
	var coin = coins[id_coin]
	return coin

#Pre: -coin is of Coin class
#     -cant_out_screen_coins < MAX_CANT_COINS
#Post: a coin is pushed to out_screen_coins
#      also the coin is removed to the group active_coins
func _pushCoin(coin):
	_checkInvariant()
	assert(cant_out_screen_coins < CANT_COINS)
	#-----------------------------------------------
	coin.setActive(false)
	id_out_screen_coins[cant_out_screen_coins] = coin.getId()
	cant_out_screen_coins += 1
	print(cant_out_screen_coins)

#Post: returns an out screen coin from coins or
#null if there is no other coin
func _get_coin():
	_checkInvariant()
	#-----------------------------------------------
	var coin = null
	
	if(cant_out_screen_coins > 0):
		coin = _pullCoin()
		coin.general_setup()
	
	
	return coin




func to_out_screen_position(obj):
	obj.set_position(OUT_SCREEN_POSITION)

#Post: a coin was dropped with MainMenu settings
func dropCoinMainMenu():
	_checkInvariant()
	#-----------------------------------------------
	var coin = _get_coin()
	if(coin != null):
		coin.setUpForMainMenu()
		_dropCoinFromAboveRand(coin)

#Post: a coin was dropped with Credits settings
func dropCoinCredits():
	_checkInvariant()
	#-----------------------------------------------
	var coin = _get_coin()
	if(coin != null):
		coin.setUpForCredits()
		CoinGlobals.setup_credits_coin_state(coin)
		_dropCoinFromAboveCentered(coin)
	

#Post: a coin was dropped with Help settings
func dropCoinHelpMenu():
	_checkInvariant()
	#-----------------------------------------------
	var coin = _get_coin()
	if(coin != null):
		coin.setUpForHelp()
		CoinGlobals.setup_help_coin(coin)
		_dropCoinFromAboveCentered(coin)
	

#Post: a coin was dropped with GameScreen settings
func dropCoinGameScreen():
	_checkInvariant()
	#-----------------------------------------------
	var coin = _get_coin()
	if(coin != null):
		coin.setUpForGameScreen(getCoinMinSpd(),getCoinMaxSpd())
		_dropCoinFromAboveRand(coin)
	

#Pre: hadaCoin!= null, hadaCoin must be of type HadamardCoin
#     hadaCoin has to have setted a minSpeed and a maxSpeed
#Post: a Hadamard coin was dropped with GameScreen settings
func dropHCoinGameScreen(hadaCoin):
	_checkInvariant()
	#-----------------------------------------------
	_dropDroppableFromAboveRand(hadaCoin)
	

#Pre: coin has to be of type Coin and has to be in_screen
#Post: coin gets pushed to out_screen_coins
func deactivate_in_screen_coin(coin):
	_checkInvariant()
	#-----------------------------------------------
	#coin.set_linear_velocity(Vector2(0, 0))
	coin.setIn_screen(false)
	to_out_screen_position(coin) #this will cause the call of deactivate_out_screen_coin(coin)

#Pre: coin has to be of type Coin and has to be out_screen
#Post: coin gets pushed to out_screen_coins
func deactivate_out_screen_coin(coin):
	_checkInvariant()
	#-----------------------------------------------
	_pushCoin(coin)
	to_out_screen_position(coin)

func deactivate_coin(coin):
	_checkInvariant()
	#-----------------------------------------------
	if(coin.isIn_screen()):
		deactivate_in_screen_coin(coin)
	else:
		deactivate_out_screen_coin(coin)

#Post: all the coins in the group Coins 
#      will change to out screen coins
func deactivate_active_coins():
	_checkInvariant()
	#-----------------------------------------------
	for coin in get_tree().get_nodes_in_group("Coins"):
		if(coin.isIn_screen()):
			deactivate_in_screen_coin(coin)
	


func _checkInvariant():
	assert(cant_out_screen_coins >= 0)
	assert(cant_out_screen_coins <= CANT_COINS)


