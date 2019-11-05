extends Node2D

const MAX_CANT_COINS = 30

var Coin = load("res://Coin.tscn")
var cant_free_coins = 0
var cant_current_coins = 0 #total coin quantity
var coins_state = []
var coins = []


func _ready():
	coins_state.resize(MAX_CANT_COINS)
	coins.resize(MAX_CANT_COINS)

#Post: devuelve un coin ya sea 
func get_coin():
	var coin = null
	
	if(cant_free_coins > 0):
		cant_free_coins -= 1
		coin = get_deactive_coin_from_coins()
		coin.general_setup()
	else:
		coin = Coin.instance()
		add_child(coin)
		coin.set_activated(true)
		coins[cant_current_coins] = coin
		cant_current_coins += 1
	
	
	return coin

#TODO OOOOOOOOOOOO


#Pre: debe haber al menos un coin con estado desactivado
#Post: devuelve un coin que estaba desactivado pero ahora con estado activado
func get_deactive_coin_from_coins():
	var i = 0
	
	while(i < cant_current_coins) and (coins[i].is_activated()):
		i += 1
	
	coins[i].set_activated(true)
	
	return coins[i]

#Pre: coin debe ser de tipo Coin
func deactivate_coin(coin):
	coin.set_activated(false)
	coin.set_linear_velocity(Vector2(0, 0))
	coin.set_position(Vector2(-150,-150))