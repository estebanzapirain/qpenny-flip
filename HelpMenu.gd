extends Control


const X_INI_ZONA_TRIGGER_FP = -132
const Y_INI_ZONA_TRIGGER_FP = 1384.5

var ZonaNoTocable = load("res://ZonaNoTocable.tscn")
var ZonaTriggerFP = load("res://ZonaTrigger.tscn") #Fuera de la pantalla

onready var hadPUSprite = $Messages/HadPUSprite
onready var backButton = $BackButton
onready var nextButton = $NextButton
onready var tipNameMessage = $Messages/TipNameMessage
onready var goodTipMessage = $Messages/GoodTipMessage
onready var badTipMessage = $Messages/BadTipMessage
onready var untouchableMessage = $Messages/UntouchableMessage
onready var cantTipsMessage = $Messages/CantTipsMessage
onready var scoreMessage = $Messages/ScoreMessage

onready var coinGenerator = $CoinGenerator


var Coin = load("res://Coin.tscn")

var zonaNoTocableAct 
var zonaTriggerFPAct


func _ready():
	get_tree().set_auto_accept_quit(false)
	hadPUSprite.set_position(Vector2(70,349))
	backButton.point_back()
	backButton.hide()
	
	creaZonaNoTocable()
	creaZonaTriggerFP()
	
	
	tipNameMessage.show()
	goodTipMessage.show()
	badTipMessage.show()
	untouchableMessage.show()
	cantTipsMessage.show()
	nextButton.show()
	
	scoreMessage.setUpForHelp()
	coins_spawn_in_Help_Menu()
	
	changeColor(GameGlobals.getCurrentColor(), GameGlobals.getCurrentColorComp())


func changeColor(color,colorComp):
	$Fondo.setColorDirecto(color)
	changeFontColor(colorComp)

func creaZonaNoTocable():
	zonaNoTocableAct = ZonaNoTocable.instance()
	add_child(zonaNoTocableAct)
	zonaNoTocableAct.appear()

func creaZonaTriggerFP():
	zonaTriggerFPAct = ZonaTriggerFP.instance()
	add_child(zonaTriggerFPAct)
	zonaTriggerFPAct.connect("body_entered", self, "coinEnZonaTriggerFP")
	zonaTriggerFPAct.set_position(Vector2(X_INI_ZONA_TRIGGER_FP, Y_INI_ZONA_TRIGGER_FP))


func coinEnZonaTriggerFP(coin):
	if(coin.state == 1):
		showScoreMessage()
	else: #coin.state == 0
		showDecreaseScoreMessage()

func showScoreMessage():
	scoreMessage.showScoreMessageTuto()


func showDecreaseScoreMessage():
	scoreMessage.showDecreaseScoreMessageTuto()





#Pre: must be called before changing the helpCoinAct number
func updateMessages(): 
	var tipAct =  CoinGlobals.getHelpTipAct()
	
	if(tipAct == 1):
		cantTipsMessage.set_text("1/3")
		tipNameMessage.add_color_override("font_color", Color("000000"))
		tipNameMessage.add_color_override("font_color_shadow", Color("ffffff"))
		tipNameMessage.set_text("Black coin:")
		goodTipMessage.set_text("+scores +1 point.")
		badTipMessage.set_text("-can be autoflipped to white \nin the mid-zone.\n-can be flipped to white by\n tapping it.")
	elif (tipAct == 2):
		hadPUSprite.hide()
		zonaNoTocableAct.deactivateHadamard()
		cantTipsMessage.set_text("2/3")
		tipNameMessage.add_color_override("font_color", Color("ffffff")) 
		tipNameMessage.add_color_override("font_color_shadow", Color("000000"))
		tipNameMessage.set_text("White coin:")
		goodTipMessage.set_text("+can be flipped to black by\n tapping it.")
		badTipMessage.set_text("\n-scores -1 point.\n-makes you lose a life in \nendless mode.")
	elif (tipAct == 3):
		cantTipsMessage.set_text("3/3")
		hadPUSprite.show()
		tipNameMessage.add_color_override("font_color", Color("2f75e6"))
		tipNameMessage.add_color_override("font_color_shadow", Color("333333"))
		tipNameMessage.set_text("      power up:")
		goodTipMessage.set_text("+makes the coins remain\nthe same in the mid-zone.")
		badTipMessage.set_text("\n-lasts a few seconds.")
	#hadPUSprite.hide()
	#zonaNoTocableAct.deactivateHadamard() add to next tip

func activateCondition():
	var tipAct =  CoinGlobals.getHelpTipAct()
	
	if (tipAct == 3):
		zonaNoTocableAct.activateHadamard()


func changeFontColor(color):
	untouchableMessage.add_color_override("font_color",color)
	cantTipsMessage.add_color_override("font_color",color)
	$BackBtt/ArrowSprite.set_modulate(color)
	nextButton.changeArrowColor(color)
	backButton.changeArrowColor(color)


func _on_NextButton_pressed():
	
	CoinGlobals.nextTip()
	
	var tipAct = CoinGlobals.getHelpTipAct()
	
	cantTipsMessage.set_text(str(tipAct) + "/" + str(CoinGlobals.CANT_TIPS) )
	
	if(tipAct == CoinGlobals.CANT_TIPS):
		nextButton.hide()
	elif (tipAct == 2):
		backButton.show()
	
	CoinGlobals.reset_help_coin_act()
	change_help_tip()


func _on_BackButton_pressed():
	
	CoinGlobals.prevTip()
	
	var tipAct = CoinGlobals.getHelpTipAct()
	
	cantTipsMessage.set_text(str(tipAct) + "/" + str(CoinGlobals.CANT_TIPS) )
	if(tipAct == 1):
		backButton.hide()
	elif (tipAct == CoinGlobals.CANT_TIPS - 1):
		nextButton.show()
	
	CoinGlobals.reset_help_coin_act()
	change_help_tip()

func eliminateCoins(): #for transitions between tips
	coinGenerator.deactivate_active_coins()


func coins_spawn_in_Help_Menu():
	CoinGlobals.reset_help_tips()
	
	CoinGlobals.setProbFlipCPU(0)
	$CoinsInHMenuTimer.start()
	
	updateMessages() #cambia los mensajes de los tips
	
	coin_spawn_in_Help_Menu() #lanzo el primer coin

func coin_spawn_in_Help_Menu():
	activateCondition()
	coinGenerator.dropCoinHelpMenu()

func change_help_tip():
	$CoinsInHMenuTimer.stop()
	updateMessages() #cambia los mensajes de los tips
	eliminateCoins()
	
	$CoinsInHMenuTimer.start()
	
	coin_spawn_in_Help_Menu() #lanzo el primer coin


func _notification(notif):
	if notif == MainLoop.NOTIFICATION_WM_QUIT_REQUEST || notif == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST:
		back_to_main_menu()
                 
func _on_BackBtt_pressed():
	back_to_main_menu()


func back_to_main_menu():
	get_tree().change_scene("res://MainMenu.tscn")

