extends RigidBody2D

var min_speed
var max_speed
var speed

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func setMinMaxSpeed( speed, amplitude ):
	min_speed = speed
	max_speed = speed + amplitude
	self.speed = rand_range(min_speed,max_speed) 

func setSpeed(speed):
	self.speed = speed


func dropFromAbove( pathOffset, direction):
    
    get_node("../CoinPath/CoinSpawnLocation").set_offset(pathOffset)
    set_position(get_node("../CoinPath/CoinSpawnLocation").get_position())
    
    # Choose the velocity.

    set_linear_velocity(Vector2(speed, 0).rotated(direction))
    show()



func dropFromAboveRand():
	var randOffset
	#SCREEN_WIDTH - 100 = 620 de ancho de pantalla efectiva
	randOffset = float(CoinGlobals.COIN_WIDHT) / 2 + randi() % int(GameGlobals.SCREEN_WIDTH_FIX + 1) 
	
#	randOffset = GameGlobals.SCREEN_WIDTH_FIX* 1 - 1 + float(CoinGlobals.COIN_WIDHT) / 2
#	print(randOffset)  
	
	var randOffsetCmp = randOffset - float(CoinGlobals.COIN_WIDHT) / 2
	# Set the pow up's direction perpendicular to the path direction.
	
	  
	var direction = 0
	#from the top clockwise --> default rot angle is 0
	
	if randOffsetCmp < GameGlobals.SCREEN_WIDTH_FIX * 0.2: #1/5 de pantalla
		direction += rand_range(PI* 0.5, PI * 0.375)
	elif randOffsetCmp < GameGlobals.SCREEN_WIDTH_FIX * 0.4: #2/5 de pantalla
		direction += rand_range(PI* 0.53, PI * 0.41)
	elif randOffsetCmp < GameGlobals.SCREEN_WIDTH_FIX * 0.6: #3/5 de pantalla
		direction += rand_range(PI* 0.565, PI * 0.435)
	elif randOffsetCmp < GameGlobals.SCREEN_WIDTH_FIX * 0.8: #4/5 de pantalla
		direction += rand_range(PI* 0.595, PI* 0.47)
	else: #5/5 de pantalla
		direction += rand_range(PI* 0.625, PI * 0.5)
	
	dropFromAbove( randOffset, direction)

func dropFromAboveCentered():
	dropFromAbove( float(CoinGlobals.COIN_WIDHT) / 2 + GameGlobals.SCREEN_WIDTH_FIX / 2 ,  PI / 2)
