extends Node2D

const POS_SCORE_LABEL_HELP = Vector2(300,1135)

onready var scoreTimer = $ScoreTimer
onready var scoreMsgLabel = $ScoreMsgLabel
onready var goodEffect = $GoodEffect
onready var badEffect = $BadEffect

# Called when the node enters the scene tree for the first time.
func _ready():
	scoreMsgLabel.hide()

func setUpForHelp():
	setPosition(POS_SCORE_LABEL_HELP)
	connectScoreTimerSignalHelp()

func showScoreMessageTuto():
	showLabelGoodMessage()
	
	playGoodEffect()


func playGoodEffect():
	goodEffect.play(0)

func showLabelGoodMessage():
	scoreMsgLabel.add_color_override("font_color", Color("44cc13")) #Green
	scoreMsgLabel.set_text("+1")
	scoreMsgLabel.show()
	
	scoreTimer.start()
	
	

func showDecreaseScoreMessageTuto():
	showLabelBadMessage()
	
	playBadEffect()

func showLabelBadMessage():
	scoreMsgLabel.add_color_override("font_color", Color("e70d0d")) #Red
	scoreMsgLabel.set_text("-1")
	scoreMsgLabel.show()
	
	scoreTimer.start()

func connectScoreTimerSignalHelp():
	scoreTimer.set_wait_time(1)
	scoreTimer.connect("timeout",self,"hideMsgLabel")

func playBadEffect():
	badEffect.play(0)

func showDecreaseScoreMessageInGame(pos):
	connectScoreTimerSignalInGame()
	setPosition(pos)
	showLabelBadMessage()

func showScoreMessageInGame(pos):
	connectScoreTimerSignalInGame()
	setPosition(pos)
	showLabelGoodMessage()

func connectScoreTimerSignalInGame():
	scoreTimer.set_wait_time(0.35)
	scoreTimer.connect("timeout",self,"deleteScoreMessage")

func setPosition(pos):
	var posX = pos.x
	if(posX < CoinGlobals.COIN_WIDHT):
		position = Vector2(CoinGlobals.COIN_WIDHT, pos.y)
	elif(posX >= GameGlobals.SCREEN_WIDTH_FIX):
		position = Vector2(GameGlobals.SCREEN_WIDTH_FIX, pos.y)
	else:
		position = pos

func hideMsgLabel():
	scoreMsgLabel.hide()

func deleteScoreMessage():
	queue_free()
