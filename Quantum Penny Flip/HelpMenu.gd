signal change_help_tip

extends Control


const X_INI_ZONA_TRIGGER_FP = -132
const Y_INI_ZONA_TRIGGER_FP = 1384.5

export (PackedScene) var ZonaNoTocable
export (PackedScene) var ZonaTriggerFP #Fuera de la pantalla

var zonaNoTocableAct 
var zonaTriggerFPAct


func _ready():
	get_node("Messages").get_node("HadPUSprite").set_pos(Vector2(70,349))
	get_node("BackButton").point_back()
	disappear()

func appear():
	show()
	
	creaZonaNoTocable()
	creaZonaTriggerFP()
	
	var messages = get_node("Messages")
	
	messages.get_node("TipNameMessage").show()
	messages.get_node("GoodTipMessage").show()
	messages.get_node("BadTipMessage").show()
	messages.get_node("UntouchableMessage").show()
	messages.get_node("CantTipsMessage").show()
	get_node("NextButton").show()

func creaZonaNoTocable():
	zonaNoTocableAct = ZonaNoTocable.instance()
	add_child(zonaNoTocableAct)
	zonaNoTocableAct.appear()

func creaZonaTriggerFP():
	zonaTriggerFPAct = ZonaTriggerFP.instance()
	add_child(zonaTriggerFPAct)
	zonaTriggerFPAct.connect("body_enter", self, "coinEnZonaTriggerFP")
	zonaTriggerFPAct.set_pos(Vector2(X_INI_ZONA_TRIGGER_FP, Y_INI_ZONA_TRIGGER_FP))

func disappear():
	hide()
	
	
	borraZonaNoTocable()
	borraZonaTriggerFP()
	
	var messages = get_node("Messages")
	
	messages.get_node("TipNameMessage").hide()
	messages.get_node("GoodTipMessage").hide()
	messages.get_node("BadTipMessage").hide()
	messages.get_node("ScoreMessage").hide()
	messages.get_node("UntouchableMessage").hide()
	messages.get_node("HadPUSprite").hide()
	messages.get_node("CantTipsMessage").hide()
	
	
	get_node("BackButton").hide()
	get_node("NextButton").hide()

func borraZonaNoTocable():
	if(zonaNoTocableAct != null):
		remove_child(zonaNoTocableAct)
		zonaNoTocableAct.queue_free() #also removes connected signals
		zonaNoTocableAct = null

func borraZonaTriggerFP():
	if(zonaTriggerFPAct != null):
		remove_child(zonaTriggerFPAct)
		zonaTriggerFPAct.queue_free()
		zonaTriggerFPAct = null

func coinEnZonaTriggerFP(coin):
	if(coin.state == 1):
		scoreMessage()
	else: #coin.state == 0
		scoreDecreaseMessage()

func scoreMessage():
	get_node("ScoreTimer").start()
	
	var scoreMessage = get_node("Messages").get_node("ScoreMessage")
	
	scoreMessage.add_color_override("font_color", Color("44cc13")) #Green
	scoreMessage.set_text("+1")
	scoreMessage.show()
	
	get_node("GoodEffect").play(0)


func scoreDecreaseMessage():
	get_node("ScoreTimer").start()
	
	var scoreMessage = get_node("Messages").get_node("ScoreMessage")
	
	scoreMessage.add_color_override("font_color", Color("e70d0d")) #Red
	scoreMessage.set_text("-1")
	scoreMessage.show()
	
	get_node("BadEffect").play(0)


func _on_ScoreTimer_timeout():
	get_node("Messages").get_node("ScoreMessage").hide()


#Pre: must be called before changing the helpCoinAct number
func updateMessages(): 
	var messages = get_node("Messages")
	var tipAct =  CoinGlobals.getHelpTipAct()
	
	if(tipAct == 1):
		messages.get_node("CantTipsMessage").set_text("1/3")
		messages.get_node("TipNameMessage").add_color_override("font_color", Color("000000"))
		messages.get_node("TipNameMessage").set_text("Black coin:")
		messages.get_node("GoodTipMessage").set_text("+scores +1 point.")
		messages.get_node("BadTipMessage").set_text("-can be autoflipped to white \nin the mid-zone.")
	elif (tipAct == 2):
		messages.get_node("HadPUSprite").hide()
		zonaNoTocableAct.deactivateHadamard()
		messages.get_node("CantTipsMessage").set_text("2/3")
		messages.get_node("TipNameMessage").add_color_override("font_color", Color("ffffff")) 
		messages.get_node("TipNameMessage").set_text("White coin:")
		messages.get_node("GoodTipMessage").set_text("+can be flipped to black by\n tapping it.")
		messages.get_node("BadTipMessage").set_text("\n-scores -1 point.\n-makes you lose a life in \nendless mode.")
	elif (tipAct == 3):
		messages.get_node("CantTipsMessage").set_text("3/3")
		messages.get_node("HadPUSprite").show()
		messages.get_node("TipNameMessage").add_color_override("font_color", Color("2f75e6"))
		messages.get_node("TipNameMessage").set_text("      power up:")
		messages.get_node("GoodTipMessage").set_text("+makes the coins remain\nthe same in the mid-zone.")
		messages.get_node("BadTipMessage").set_text("\n-lasts a few seconds.")
	#messages.get_node("HadPUSprite").hide()
	#zonaNoTocableAct.deactivateHadamard() add to next tip

func activateCondition():
	var tipAct =  CoinGlobals.getHelpTipAct()
	
	if (tipAct == 3):
		zonaNoTocableAct.activateHadamard()


func changeFontColor(color):
	get_node("Messages/UntouchableMessage").add_color_override("font_color",color)
	get_node("Messages/CantTipsMessage").add_color_override("font_color",color)
	get_node("NextButton").changeArrowColor(color)
	get_node("BackButton").changeArrowColor(color)


func _on_NextButton_pressed():
	eliminateCoins()
	
	CoinGlobals.nextTip()
	
	var tipAct = CoinGlobals.getHelpTipAct()
	
	get_node("Messages/CantTipsMessage").set_text(str(tipAct) + "/" + str(CoinGlobals.CANT_TIPS) )
	
	if(tipAct == CoinGlobals.CANT_TIPS):
		get_node("NextButton").hide()
	elif (tipAct == 2):
		get_node("BackButton").show()
	
	CoinGlobals.reset_help_coin_act()
	updateMessages()
	emit_signal("change_help_tip")


func _on_BackButton_pressed():
	eliminateCoins()
	
	CoinGlobals.prevTip()
	
	var tipAct = CoinGlobals.getHelpTipAct()
	
	get_node("Messages/CantTipsMessage").set_text(str(tipAct) + "/" + str(CoinGlobals.CANT_TIPS) )
	if(tipAct == 1):
		get_node("BackButton").hide()
	elif (tipAct == CoinGlobals.CANT_TIPS - 1):
		get_node("NextButton").show()
	
	CoinGlobals.reset_help_coin_act()
	updateMessages()
	emit_signal("change_help_tip")

func eliminateCoins(): #for transitions
	for coin in get_tree().get_nodes_in_group("Coins"):
		coin.queue_free()
