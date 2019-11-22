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


onready var creditsTL = get_node("CreditsTitleLeft")
onready var creditsBL1 = get_node("CreditsBodyLeft1")
onready var creditsBL2 = get_node("CreditsBodyLeft2")
onready var creditsTR = get_node("CreditsTitleRight")
onready var creditsBR1 = get_node("CreditsBodyRight1")
onready var creditsBR2 = get_node("CreditsBodyRight2")

onready var coinGenerator = $CoinGenerator

onready var coinSmashSound = get_node("CoinSmash")

var colorAct
var colorCompAct
var nroCreditAct = 1
var nroCoinAct = 1

var ZonaTrigger = preload("ZonaTrigger.tscn")
var Coin = preload("Coin.tscn")
var zonaTrigger

func _ready():
	get_tree().set_auto_accept_quit(false)
	nroCreditAct = 1
	nroCoinAct = 1
	setupCreditsText()
	colorAct = GameGlobals.getCurrentColor()
	colorCompAct = GameGlobals.getCurrentColorComp()
	changeColor(colorAct,colorCompAct)
	
	creaZonaTrigger()
	coins_spawn_in_credits()
	
	show()
	$CreditsSong.play()


func desp_X_CT(cant):
	creditsTL.set_position(Vector2( X_INI_CTL +  cant, Y_INI_CTL))
	creditsTR.set_position(Vector2( X_INI_CTR + cant, Y_INI_CTR))

func desp_X_CTL(cant):
	creditsTL.set_position(Vector2( X_INI_CTL +  cant, Y_INI_CTL))
	

func desp_X_CB1(cant):
	creditsBL1.set_position(Vector2( X_INI_CBL1 +  cant, Y_INI_CBL1))
	creditsBR1.set_position(Vector2( X_INI_CBR1 + cant, Y_INI_CBR1))

func desp_X_CB2(cant):
	creditsBL1.set_position(Vector2( X_INI_CBL1 +  cant, Y_INI_CBL1))
	creditsBR1.set_position(Vector2( X_INI_CBR1 + cant, Y_INI_CBR1))

func desp_Y_ZT(cant):
	zonaTrigger.set_position(Vector2(X_INI_ZONA_TRIGGER, Y_INI_ZONA_TRIGGER + cant))

func changeColor(color,colorComp):
	$Fondo.setColorDirecto(color)
	changeFontColor(colorComp)
	setColorAct(colorComp)

func changeFontColor(color):
	changeFontColorLeft(color)
	changeFontColorRight(color)
	
	$BackButton/ArrowSprite.set_modulate(color)
	

func changeFontColorLeft(color):
	var colorComp = Color(1-color.r,1-color.g,1-color.b)
	
	creditsTL.add_color_override("font_color",color)
	creditsBL1.add_color_override("font_color",color)
	creditsBL2.add_color_override("font_color",color)
	creditsTL.add_color_override("font_color_shadow",colorComp)
	creditsBL1.add_color_override("font_color_shadow",colorComp)
	creditsBL2.add_color_override("font_color_shadow",colorComp)

func changeFontColorRight(color):
	var colorComp = Color(1-color.r,1-color.g,1-color.b)
	
	creditsTR.add_color_override("font_color",color)
	creditsBR1.add_color_override("font_color",color)
	creditsBR2.add_color_override("font_color",color)
	creditsTR.add_color_override("font_color_shadow",colorComp)
	creditsBR1.add_color_override("font_color_shadow",colorComp)
	creditsBR2.add_color_override("font_color_shadow",colorComp)


func creaZonaTrigger():
	zonaTrigger = ZonaTrigger.instance()
	add_child(zonaTrigger)
	zonaTrigger.connect("body_entered", self, "changeColorFontsCoin")


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
		print("hbuffed")
		if(coin.state == 1): #White-Black
			changeFontColorLeft(Color(0,0,0))
			changeFontColorRight(Color(1,1,1))
		else:  #Black-white
			changeFontColorLeft(Color(1,1,1))
			changeFontColorRight(Color(0,0,0))
	
	coinSmashSound.play()
	coinGenerator.deactivate_in_screen_coin(coin)
	
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
	creditsTL.set_text(CTL_WORDS[nroCreditAct - 1])
	creditsTR.set_text(CTR_WORDS[nroCreditAct - 1])
	desp_X_CT(CT_DESP_X[nroCreditAct - 1] )
	
	
	creditsBL1.set_text(CBL1_WORDS[nroCreditAct - 1])
	creditsBR1.set_text(CBR1_WORDS[nroCreditAct - 1])
	desp_X_CB1(CB1_DESP_X[nroCreditAct - 1] )
	
	creditsBL2.set_text(CBL2_WORDS[nroCreditAct - 1])
	creditsBR2.set_text(CBR2_WORDS[nroCreditAct - 1])
	desp_X_CB2(CB2_DESP_X[nroCreditAct - 1] )



func coins_spawn_in_credits():
	CoinGlobals.initCreditsCoinTypes()
	
	$CoinsInCreditsTimer.start()
	
	coin_spawn_in_credits() #lanzo el primer coin

func coin_spawn_in_credits():
	coinGenerator.dropCoinCredits()


func _notification(notif):
	if notif == MainLoop.NOTIFICATION_WM_QUIT_REQUEST || notif == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST:
		back_to_main_menu()
                 
func _on_BackButton_pressed():
	back_to_main_menu()


func back_to_main_menu():
	get_tree().change_scene("res://MainMenu.tscn")