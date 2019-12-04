extends Control

const CANT_PREG = 5
const PREGUNTAS = ["¿El juego te pareció divertido?", 
                   "¿Entendiste qué se suponía que tenías que hacer?", 
                   "¿Te pareció fácil o difícil?", 
                   "¿Seguirías jugando más niveles?", 
                   "¿Le recomendarías a un amigo que lo juegue?"]

const RTAS_OP5  = ["Muy divertido", 
                   "Sí, al toque.", 
                   "Muy difícil", 
                   "Sí, me quedé con ganas de jugar más!", 
                   "Sí, lo voy a recomendar."]

const RTAS_OP4  = ["Bastante divertido",
                   "Sí, lo entendí.",
                   "Bastante difícil", 
                   "Podría ser...", 
                   "Puede ser, si me preguntan."]

const RTAS_OP3  = ["Más o menos divertido", 
                   "Me costó pero lo entendí.",
                   "Ni fácil ni difícil",
                   "Capaz que sí, capaz que no.",
                   "No sé."]

const RTAS_OP2  = ["Poco divertido",
                   "No estoy seguro si lo entendí.",
                   "Bastante fácil",
                   "No creo.",
                   "No, no creo."]

const RTAS_OP1  = ["Para nada divertido", 
                   "No, no lo pude entender",
                   "Muy fácil",
                   "No, no lo jugaría más.",
                   ""]

onready var labelTitle   = $MarginContainer/VBoxContainer/LabelTitle
onready var labelMessage = $LabelMessage
onready var containerRtas = $MarginContainer/VBoxContainer/MCRtas/VBRtas
onready var labelMessageTimer = $LabelMessageTimer

var OpcionMultipleChoice = load("res://OpcionMultipleChoice.tscn")

var RTAS = []
var rtasElegidas = []

var nPregAct = 0

func _ready():
	RTAS = [RTAS_OP1, RTAS_OP2, RTAS_OP3, RTAS_OP4, RTAS_OP5]
	rtasElegidas.resize(CANT_PREG)
	
	$Fondo.show()
	labelTitle.hide()
	containerRtas.hide()
	creaOpcionesMultipleChoice()
	
	var color
	var colorComp
	color = GameGlobals.getCurrentColor()
	colorComp = GameGlobals.getCurrentColorComp()
	changeColor(color,colorComp)
	
	showMessage("Ayudanos a mejorar el juego respondiendo una serie de preguntas", 5)
	yield(labelMessageTimer, "timeout")
	
	labelTitle.show()
	cambiaPregunta()
	containerRtas.show()
	

func changeColor(color,colorComp):
	$Fondo.setColorDirecto(color)
	
	for opMultipleChoice in get_tree().get_nodes_in_group("OpcionesMultipleChoice"):
		opMultipleChoice.changeColor(color, colorComp)
	
	labelTitle.add_color_override("font_color",colorComp)
	labelMessage.add_color_override("font_color",colorComp)
	


func showMessage(message, timeInScreen):
	labelMessage.text = message
	labelMessage.show()
	labelMessageTimer.set_wait_time(timeInScreen)
	labelMessageTimer.start()
	

func _on_LabelMessageTimer_timeout():
	hideMessage()

func hideMessage():
	labelMessage.hide()

func creaOpcionesMultipleChoice():
	var opcionMultipleChoice
	for i in range(CANT_PREG):
		opcionMultipleChoice = OpcionMultipleChoice.instance()
		containerRtas.add_child(opcionMultipleChoice)
		opcionMultipleChoice.setNumeroOpcion(CANT_PREG - i)
		opcionMultipleChoice.connect("rta_elegida", self, "guardarOpcionElegida")



func guardarOpcionElegida(rta):
	rtasElegidas[nPregAct - 1] = rta
	
	
	if(nPregAct < CANT_PREG):
		cambiaPregunta()
	else:
		enviaResultadoEncuesta()
		hidePreguntasyRtas()
		showMessage("Gracias por su colaboracion.", 4)
		yield(labelMessageTimer, "timeout")
		toMainMenu()


func cambiaPregunta():
	nPregAct += 1
	
	labelTitle.text = "Pregunta " + str(nPregAct) + "/" + str(CANT_PREG) + ":\n" + PREGUNTAS[nPregAct - 1]
	
	var strAux
	
	for opMultipleChoice in get_tree().get_nodes_in_group("OpcionesMultipleChoice"):
		strAux = RTAS[opMultipleChoice.getNumeroOpcion() - 1][nPregAct - 1]
		
		if(strAux != ""):
			opMultipleChoice.show()
			opMultipleChoice.setDesc(strAux)
		else:
			opMultipleChoice.hide()


func hidePreguntasyRtas():
	labelTitle.hide()
	for opMultipleChoice in get_tree().get_nodes_in_group("OpcionesMultipleChoice"):
		opMultipleChoice.hide()


func enviaResultadoEncuesta():
	#rtasElegidas
	RedGodot._send_event(rtasElegidas[0], rtasElegidas[1], rtasElegidas[2], rtasElegidas[3], rtasElegidas[4])

func toMainMenu():
	cambia_escena("res://MainMenu.tscn")

func cambia_escena(scenePath):
	get_tree().change_scene(scenePath)




