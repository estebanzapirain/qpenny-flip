extends Node

export (PackedScene) var Coin
var score
const gameTime = 60
const stopCoinSpawnTime = 3
var playtime
var coinAct = 0
var screenWeight = OS.get_window_size().x

func _ready():
	randomize()

func game_over():
    get_node("MobTimer").stop()
    get_node("GameEndingTimer").stop()
    get_node("HUD").show_game_over()

func stop_coin_spawn():
    get_node("MobTimer").stop()

func new_game():
    playtime = gameTime
    score = 0
    get_node("StartTimer").start()
    get_node("HUD").update_score(score)
    get_node("HUD").show_message("Get Ready")
    get_node("HUD").init_game_timer(gameTime)

func _on_MobTimer_timeout():
   # Choose a random location on Path2D.
    var randOffset
    randOffset = screenWeight / 4 + randi() % int(screenWeight / 2) 
    
    
    get_node("CoinPath/CoinSpawnLocation").set_offset(randOffset)
    # Create a Coin instance and add it to the scene.
    var coin = Coin.instance()
    add_child(coin)
    # Set the coin's direction perpendicular to the path direction.
    var direction = get_node("CoinPath/CoinSpawnLocation").get_rot()
    # Set the coin's position to a random location.
    coin.set_pos(get_node("CoinPath/CoinSpawnLocation").get_pos())
    # Add some randomness to the direction.

    direction += rand_range(-PI* 0.55, -PI * 0.45)
    coin.set_rot(direction)
    # Choose the velocity.
    coin.set_linear_velocity(Vector2(rand_range(coin.min_speed, coin.max_speed), 0).rotated(direction))
    


func scores():
    score += 1
    get_node("HUD").update_score(score)


func _on_StartTimer_timeout():
    get_node("MobTimer").start()
    get_node("GameEndingTimer").start()


func _on_GameEndingTimer_timeout():
    playtime -= 1
    get_node("HUD").update_playtime(playtime)
    if playtime == 0:
        game_over()
    elif playtime <= stopCoinSpawnTime:
        stop_coin_spawn()

func on_hadamard_power_up():
    get_node("Qubit").h_gate()

