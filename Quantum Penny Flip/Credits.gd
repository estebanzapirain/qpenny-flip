extends Control


const CTL_WORDS = ["Progra","Game","Game C","Mu","A","Thanks fo"]
const CTR_WORDS = ["mming"," Design","oncept","sic","rt","r playing!"]

const CBL1_WORDS = ["Juan Pabl","Juan Pabl","Esteban", "Francisco \"P","Juan Pabl",""]
const CBR1_WORDS = ["o Cardoso","o Cardoso"," Zapirain","ancho\" Calo","o Cardoso",""]

const CBL2_WORDS = ["","","","bensou","",""]
const CBR2_WORDS = ["","","","nd.com","",""]

#benso und.com

const CT_DESP_X = [-15, -30, 0, -10, -16,0]
const CB1_DESP_X = [0,     0, 0,   0, 0,0]
const CB2_DESP_X = [0,     0, 0,   0, 0,0]

const X_INI_CTL = 6
const Y_INI_CTL = 498

const X_INI_CTR = 376
const Y_INI_CTR = 498

const X_INI_CBL1= 1
const Y_INI_CBL1 = 626

const X_INI_CBR1 = 363
const Y_INI_CBR1 = 626

const X_INI_CBL2= 1
const Y_INI_CBL2 = 716

const X_INI_CBR2 = 363
const Y_INI_CBR2 = 716

const SIZE_INI_CTL = Vector2(370,98)
const SIZE_INI_CTR = Vector2(341,98)

const SIZE_INI_CBL1 = Vector2(363,99)
const SIZE_INI_CBR1 = Vector2(357,99)

const SIZE_INI_CBL2 = Vector2(363,99)
const SIZE_INI_CBR2 = Vector2(357,99)

const X_INI_ZONA_TRIGGER = 0
const Y_INI_ZONA_TRIGGER = 670


const CANT_CREDITS = 6
const CANT_COINS_PER_CREDIT = 4

var colorAct
var nroCreditAct = 1
var nroCoinAct = 1

export (PackedScene) var ZonaTrigger

var zonaTrigger

func _ready():
	get_node("CreditsSong").set_loop(true)
	

func desp_X_CT(cant):
	get_node("CreditsTitleLeft").set_pos(Vector2( X_INI_CTL +  cant, Y_INI_CTL))
	get_node("CreditsTitleRight").set_pos(Vector2( X_INI_CTR + cant, Y_INI_CTR))

func desp_X_CTL(cant):
	get_node("CreditsTitleLeft").set_pos(Vector2( X_INI_CTL +  cant, Y_INI_CTL))
	

func desp_X_CB1(cant):
	get_node("CreditsBodyLeft1").set_pos(Vector2( X_INI_CBL1 +  cant, Y_INI_CBL1))
	get_node("CreditsBodyRight1").set_pos(Vector2( X_INI_CBR1 + cant, Y_INI_CBR1))

func desp_X_CB2(cant):
	get_node("CreditsBodyLeft1").set_pos(Vector2( X_INI_CBL1 +  cant, Y_INI_CBL1))
	get_node("CreditsBodyRight1").set_pos(Vector2( X_INI_CBR1 + cant, Y_INI_CBR1))

func desp_Y_ZT(cant):
	zonaTrigger.set_pos(Vector2(X_INI_ZONA_TRIGGER, Y_INI_ZONA_TRIGGER + cant))

func changeFontColor(color):
	changeFontColorLeft(color)
	changeFontColorRight(color)
	setColorAct(color)

func changeFontColorLeft(color):
	get_node("CreditsTitleLeft").add_color_override("font_color",color)
	get_node("CreditsBodyLeft1").add_color_override("font_color",color)
	get_node("CreditsBodyLeft2").add_color_override("font_color",color)

func changeFontColorRight(color):
	get_node("CreditsTitleRight").add_color_override("font_color",color)
	get_node("CreditsBodyRight1").add_color_override("font_color",color)
	get_node("CreditsBodyRight2").add_color_override("font_color",color)

func appear():
	nroCreditAct = 1
	nroCoinAct = 1
	setupCreditsText()
	changeFontColor(colorAct)
	
	creaZonaTrigger()
	
	show()
	get_node("CreditsSong").play()

func creaZonaTrigger():
	zonaTrigger = ZonaTrigger.instance()
	
	add_child(zonaTrigger)
	zonaTrigger.connect("body_enter", self, "changeColorFontsCoin")

func disappear():
	borraZonaTrigger()
	
	hide()
	get_node("CreditsSong").stop()

func borraZonaTrigger():
	if(zonaTrigger != null):
		remove_child(zonaTrigger)
		zonaTrigger.queue_free()
		zonaTrigger = null

func setColorAct(color):
	colorAct = color

func changeColorFontsCoin(coin):
	if(!coin.isHBuffed()):
		if (coin.state == 1): #Black
			changeFontColorLeft(Color(0,0,0))
			changeFontColorRight(Color(0,0,0))
		else: #White
			changeFontColorLeft(Color(1,1,1))
			changeFontColorRight(Color(1,1,1))
	else: 
		if(coin.state == 1): #White-Black
			changeFontColorLeft(Color(0,0,0))
			changeFontColorRight(Color(1,1,1))
		else:  #Black-white
			changeFontColorLeft(Color(1,1,1))
			changeFontColorRight(Color(0,0,0))
	
	get_node("CoinSmash").play()
	coin.queue_free()
	
	if (nroCoinAct == CANT_COINS_PER_CREDIT):
		nroCoinAct = 1
		if (nroCreditAct < CANT_CREDITS):
			nroCreditAct += 1
			setupCreditsText()
			changeFontColor(colorAct)
		
		if (nroCreditAct == CANT_CREDITS):
			desp_X_CTL(-5)
			desp_Y_ZT(-40)
	else:
		nroCoinAct += 1

func setupCreditsText():
	get_node("CreditsTitleLeft").set_text(CTL_WORDS[nroCreditAct - 1])
	get_node("CreditsTitleRight").set_text(CTR_WORDS[nroCreditAct - 1])
	desp_X_CT(CT_DESP_X[nroCreditAct - 1] )
	
	
	get_node("CreditsBodyLeft1").set_text(CBL1_WORDS[nroCreditAct - 1])
	get_node("CreditsBodyRight1").set_text(CBR1_WORDS[nroCreditAct - 1])
	desp_X_CB1(CB1_DESP_X[nroCreditAct - 1] )
	
	get_node("CreditsBodyLeft2").set_text(CBL2_WORDS[nroCreditAct - 1])
	get_node("CreditsBodyRight2").set_text(CBR2_WORDS[nroCreditAct - 1])
	desp_X_CB2(CB2_DESP_X[nroCreditAct - 1] )








                    


