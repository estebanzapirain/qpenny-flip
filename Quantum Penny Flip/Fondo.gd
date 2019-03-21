extends CanvasLayer

var r #r,g and b saves the actual color code
var g
var b

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func hide():
	get_node("ColorFondo").hide()


func show():
	get_node("ColorFondo").show()


func setColorFondo(nLevel): #rgb colors between 0 and 1 gris verde  violeta rojo dorado
	
	
	if (nLevel <= QPFGlobals.CANT_LEVELS / 4): #ColorIni = (21/255,155/255,156/255) cyan,  ColorFin = (0,0.5,0) dark green
		r = graduaColor(QPFGlobals.CANT_LEVELS / 4, nLevel, 5, 21.0/255, 0)
		g = graduaColor(QPFGlobals.CANT_LEVELS / 4, nLevel, 5, 155.0/255, 0.5)
		b = graduaColor(QPFGlobals.CANT_LEVELS / 4, nLevel, 5, 156.0/255, 0)
	elif (nLevel <= QPFGlobals.CANT_LEVELS / 2):  #ColorIni = (0,0.5,0) dark green,  ColorFin = (0.5,0,0.5) dark violet
		r = graduaColor(QPFGlobals.CANT_LEVELS / 2, nLevel, 5, 0, 0.5)
		g = graduaColor(QPFGlobals.CANT_LEVELS / 2, nLevel, 5, 0.5, 0)
		b = graduaColor(QPFGlobals.CANT_LEVELS / 2, nLevel, 5, 0, 0.5)
	elif (nLevel <= QPFGlobals.CANT_LEVELS * (3 / float(4) ) ): #ColorIni = (0.5,0,0.5) dark violet,  ColorFin = (0.5,0,0) dark red
		r = 0.5
		g = 0
		b = graduaColor(QPFGlobals.CANT_LEVELS * (3 / float(4)), nLevel, 5, 0.5, 0)
	elif (nLevel <= QPFGlobals.CANT_LEVELS ): #ColorIni = (0.5,0,0) dark red dark,  ColorFin = (0.5,0.5,0) dark yellow
		r = 0.5
		g = graduaColor(QPFGlobals.CANT_LEVELS, nLevel, 5, 0, 0.5)
		b = 0
	else: #(nLevel <= QPFGlobals.CANT_LEVELS ):  #ColorIni = (0.5,0.5,0) dark yellow,  ColorFin = (21/255,155/255,156/255) cyan
		r = graduaColor(QPFGlobals.CANT_LEVELS * (5 / float(4) ), nLevel, 5, 0.5, float(21)/255)
		g = graduaColor(QPFGlobals.CANT_LEVELS * (5 / float(4) ), nLevel, 5, 0.5, float(155)/255)
		b = graduaColor(QPFGlobals.CANT_LEVELS * (5 / float(4) ), nLevel, 5, 0, float(156)/255)
	
	get_node("ColorFondo").set_frame_color(Color(r, g, b) )

func graduaColor(nivelTope, nLevel, difIni, valorIni, valorFin):
	if(valorIni < valorFin):
		return graduaColorAsc(nivelTope, nLevel, difIni, valorIni, valorFin)
	else:
		return graduaColorDesc(nivelTope, nLevel, difIni, valorIni, valorFin)

func graduaColorDesc(nivelTope, nLevel, difIni, valorIni, valorFin):
	return valorFin + ( (valorIni - valorFin) / difIni) * ( nivelTope - nLevel )

func graduaColorAsc(nivelTope, nLevel, difIni, valorIni, valorFin):
	return valorFin - ( (valorFin - valorIni) / difIni) * ( nivelTope - nLevel )


func getColorComplementario():
	return Color(1-r,1-g,1-b) 

func setIgnoreMouse(cond):
	get_node("ColorFondo").set_ignore_mouse(cond)

func setStopMouse(cond):
	get_node("ColorFondo").set_stop_mouse(cond)
