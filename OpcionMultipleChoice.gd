signal rta_elegida

extends Control

var numeroOpcion  setget setNumeroOpcion, getNumeroOpcion

onready var btElegir  = $MarginContainer/HBoxContainer/ButtonElegir
onready var btSpriteBorders  = $MarginContainer/HBoxContainer/ButtonElegir/SpriteBorders
onready var btSpriteFilling  = $MarginContainer/HBoxContainer/ButtonElegir/SpriteFilling
onready var labelDesc = $MarginContainer/HBoxContainer/LabelDesc
onready var timerPostRta = $TimerPostRta

func _ready():
	changeToUnchecked()

func setNumeroOpcion(number):
	numeroOpcion = number

func getNumeroOpcion():
	return numeroOpcion

func setDesc(strDesc):
	labelDesc.text = strDesc

func _on_ButtonElegir_pressed():
	disableBts()
	
	changeToChecked()
	timerPostRta.start()
	yield(timerPostRta, "timeout")
	emit_signal("rta_elegida", getNumeroOpcion())
	changeToUnchecked()
	
	enableBts()

func changeToUnchecked():
	btSpriteBorders.frame = 1

func changeToChecked():
	btSpriteBorders.frame = 0

func changeColor(color, colorComp):
	labelDesc.add_color_override("font_color",colorComp)
	btSpriteBorders.modulate = colorComp
	btSpriteFilling.modulate = color

func disableBts():
	for op in get_tree().get_nodes_in_group("OpcionesMultipleChoice"):
		op.setDisabled()

func enableBts():
	for op in get_tree().get_nodes_in_group("OpcionesMultipleChoice"):
		op.setEnabled()

func setDisabled():
	btElegir.disabled = true

func setEnabled():
	btElegir.disabled = false
