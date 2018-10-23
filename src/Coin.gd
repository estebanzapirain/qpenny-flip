extends RigidBody2D

export (int) var min_speed # Minimum speed range.
export (int) var max_speed # Maximum speed range.
var state
var mob_types = ["white", "black"]

func _ready():
    state = randi() % 2 # Genera un estado inicial aleatorio
    get_node("AnimatedSprite").animation = mob_types[state]
    get_node("AnimatedSprite").play() # Asigna la animación
    set_process_input(true)

func _on_Coin_body_enter( body ):
    if body.getname() == "Player": 		# si el jugador toca la moneda?
      state = (state + 1) % 2 			# invierte el estado
    get_node("AnimatedSprite").animation = mob_types[state] # asigna la animación



func _input_event(viewport, event, shape_idx):
    if event.type == InputEvent.MOUSE_BUTTON:
        if event.button_index == BUTTON_LEFT and event.pressed: # si hay tap o clic izquierdo
            state = (state + 1) % 2 # invierte el estado
            get_node("AnimatedSprite").animation = mob_types[state]


func _on_Visibility_exit_screen():
	queue_free()
