extends CanvasLayer

onready var fondoStopMouse = $FondoStopMouse
onready var imagenFondo = $ImagenFondo

var r #r,g and b saves the actual color code
var g
var b


func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func hide():
	imagenFondo.hide()


func show():
	imagenFondo.show()

func setColorDirecto(color):
	r =color.r
	g =color.g
	b =color.b
	imagenFondo.set_modulate(color )


func setColorFondo(nLevel): #rgb colors between 0 and 1 gris verde  violeta rojo dorado
	
	
	if (nLevel <= GameGlobals.CANT_LEVELS / 4): #ColorIni = (21/255,155/255,156/255) cyan,  ColorFin = (0,0.5,0) dark green
		r = graduaColor(GameGlobals.CANT_LEVELS / 4, nLevel, 5, 21.0/255, 0)
		g = graduaColor(GameGlobals.CANT_LEVELS / 4, nLevel, 5, 155.0/255, 0.5)
		b = graduaColor(GameGlobals.CANT_LEVELS / 4, nLevel, 5, 156.0/255, 0)
	elif (nLevel <= GameGlobals.CANT_LEVELS / 2):  #ColorIni = (0,0.5,0) dark green,  ColorFin = (0.5,0,0.5) dark violet
		r = graduaColor(GameGlobals.CANT_LEVELS / 2, nLevel, 5, 0, 0.5)
		g = graduaColor(GameGlobals.CANT_LEVELS / 2, nLevel, 5, 0.5, 0)
		b = graduaColor(GameGlobals.CANT_LEVELS / 2, nLevel, 5, 0, 0.5)
	elif (nLevel <= GameGlobals.CANT_LEVELS * (3 / float(4) ) ): #ColorIni = (0.5,0,0.5) dark violet,  ColorFin = (0.5,0,0) dark red
		r = 0.5
		g = 0
		b = graduaColor(GameGlobals.CANT_LEVELS * (3 / float(4)), nLevel, 5, 0.5, 0)
	elif (nLevel <= GameGlobals.CANT_LEVELS ): #ColorIni = (0.5,0,0) dark red dark,  ColorFin = (0.5,0.5,0) dark yellow
		r = 0.5
		g = graduaColor(GameGlobals.CANT_LEVELS, nLevel, 5, 0, 0.5)
		b = 0
	else: #(nLevel <= GameGlobals.CANT_LEVELS ):  #ColorIni = (0.5,0.5,0) dark yellow,  ColorFin = (21/255,155/255,156/255) cyan
		r = graduaColor(GameGlobals.CANT_LEVELS * (5 / float(4) ), nLevel, 5, 0.5, float(21)/255)
		g = graduaColor(GameGlobals.CANT_LEVELS * (5 / float(4) ), nLevel, 5, 0.5, float(155)/255)
		b = graduaColor(GameGlobals.CANT_LEVELS * (5 / float(4) ), nLevel, 5, 0, float(156)/255)
	
	setColorDirecto(Color(r, g, b) )

func graduaColor(nivelTope, nLevel, difIni, valorIni, valorFin):
	if(valorIni < valorFin):
		return graduaColorAsc(nivelTope, nLevel, difIni, valorIni, valorFin)
	else:
		return graduaColorDesc(nivelTope, nLevel, difIni, valorIni, valorFin)

func graduaColorDesc(nivelTope, nLevel, difIni, valorIni, valorFin):
	return valorFin + ( (valorIni - valorFin) / difIni) * ( nivelTope - nLevel )

func graduaColorAsc(nivelTope, nLevel, difIni, valorIni, valorFin):
	return valorFin - ( (valorFin - valorIni) / difIni) * ( nivelTope - nLevel )

func getColor():
	return Color(r,g,b) 

func getColorComplementario():
	return Color(1-r,1-g,1-b) 

func setStopMouse():
	fondoStopMouse.mouse_filter = fondoStopMouse.MOUSE_FILTER_STOP

func setIgnoreMouse():
	fondoStopMouse.mouse_filter = fondoStopMouse.MOUSE_FILTER_IGNORE

