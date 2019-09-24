signal HadPowUP_on

extends "Droppable.gd"

const BASE_HAD_PU_SPEED = 250
const BASE_HAD_PU_SPEED_AMP = 50
const HAD_PU_SPEED_INC_RATE = 100 / (24 - 1)
const HAD_PU_SPEED_AMP_INC_RATE = 25 / (24 - 1)


func _ready():
    init()
    set_process_input(true)

func init():
    hide()
    set_linear_velocity(Vector2(0,0))
    

func _on_AreaTocable_pressed():
	init()
	get_node("TouchSound").play()
	emit_signal("HadPowUP_on")

func _on_Visibility_exit_screen():
    init()

func update_Speeds(levelAct):
	var aux_min_speed = BASE_HAD_PU_SPEED + HAD_PU_SPEED_INC_RATE * (levelAct - 1)
	var aux_max_speed = aux_min_speed + BASE_HAD_PU_SPEED_AMP + HAD_PU_SPEED_AMP_INC_RATE * (levelAct - 1)
	setMinMaxSpeed(aux_min_speed, aux_max_speed)
  



