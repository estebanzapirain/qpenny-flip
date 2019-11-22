extends KinematicBody2D

var speed setget setSpeed,getSpeed
var linear_speed setget _setLinearSpeed,_getLinearSpeed

# Called when the node enters the scene tree for the first time.
func _ready():
	set_physics_process(false)
	

func _physics_process(delta):
	move_and_collide(linear_speed*delta)


#Pre:   -speed >= 0
#		-spdAmp >= 0
#Post: a speed for the Droppable is seted in the range [speed,speed+spdAmp]
func setMinMaxSpeed( speed:float, spdAmp:float ):
	setSpeed(rand_range(speed,speed + spdAmp)) 

func setSpeed(value):
	speed = value

func getSpeed():
	return speed

func _setLinearSpeed(vector):
	linear_speed = vector

func _getLinearSpeed():
	return linear_speed

#Pre:   - pos != null
#		- 49 <= pos.x <= 671 
#		- -1 <= pos.y <= 1 
#		- 0 <= (direction mod 2PI) <= PI
#Post: the droppable will be dropped from the specified pos 
#with direction in directionAngle
func dropFromAbove(pos:Vector2, directionAngle:float)->void:
	set_position(pos)
	_setLinearSpeed(Vector2(getSpeed()*cos(directionAngle),getSpeed()*sin(directionAngle)))
	set_physics_process(true)

