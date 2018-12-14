signal HadPowUP_on

extends RigidBody2D

const BASE_HAD_PU_SPEED = 250
const BASE_HAD_PU_SPEED_AMP = 50
const HAD_PU_SPEED_INC_RATE = 1.025
const HAD_PU_SPEED_AMP_INC_RATE = 1.025

export (int) var min_speed # Minimum speed range.
export (int) var max_speed # Maximum speed range.

func _ready():
    init()
    set_process_input(true)

func init():
    hide()
    set_linear_velocity(Vector2(0,0))
    

func _input_event(viewport, event, shape_idx):
    if !QPFGlobals.isPaused() and event.type == InputEvent.MOUSE_BUTTON:
            if event.button_index == BUTTON_LEFT and event.pressed:
                init()
                emit_signal("HadPowUP_on")

func _on_Visibility_exit_screen():
    init()

func update_Speeds(levelAct):
    min_speed = BASE_HAD_PU_SPEED * pow(HAD_PU_SPEED_INC_RATE,levelAct - 1)
    max_speed = min_speed + BASE_HAD_PU_SPEED_AMP * pow(HAD_PU_SPEED_AMP_INC_RATE,levelAct - 1)

  