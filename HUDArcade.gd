signal start_game
signal stop_game
signal back_to_level_select_menu
signal next_level

extends "HUD.gd"


onready var nextRankLabel = $PMLayer/PauseMenu/VBoxContainer/VBoxContainer2/NextRankLabel
onready var scoreStars = $PMLayer/PauseMenu/VBoxContainer/VBoxContainer2/ScoreStars
onready var PMButtons = $PMLayer/PauseMenu/VBoxContainer/PMButtons
onready var PMNextLevelButton = $PMLayer/PauseMenu/VBoxContainer/PMButtons/NextLevelButton
onready var PMLevelMenuButton = $PMLayer/PauseMenu/VBoxContainer/PMButtons/LevelMenuButton
onready var levelLabel = $LevelLabel
onready var scoreStarsTimer = $Timers/ScoreStarsTimer
onready var nextRankLabelTimer = $Timers/NextRankLabelTimer

var ScoreMessage = load("res://ScoreMessage.tscn")

var world_highscores = []
var world_cantStars  = []

var scrOneStarAct
var scrTwoStarsAct
var scrThreeStarsAct
var scrToNextStar

# Called when the node enters the scene tree for the first time.
func _ready():
	init_HS_CS()
	scoreStars.show()
	hideHUD()


func creaScoreMessage(pos):
	var scoreMessage = ScoreMessage.instance()
	add_child(scoreMessage)
	scoreMessage.showScoreMessageInGame(pos)

func creaDecreaseScoreMessage(pos):
	var scoreMessage = ScoreMessage.instance()
	add_child(scoreMessage)
	scoreMessage.showDecreaseScoreMessageInGame(pos)


func _on_NextLevelButton_pressed():
	emit_signal("next_level")

func setMessageFontColors(color):
	.setMessageFontColors(color)
	levelLabel.add_color_override("font_color",color)
	gameTimerLabel.add_color_override("font_color",color)
	nextRankLabel.add_color_override("font_color",color)
	PMNextLevelButton.add_color_override("font_color",color)
	PMLevelMenuButton.add_color_override("font_color",color)



func showHUD(world,nLevel):
	PMNextLevelButton.hide()
	#levelLabel.set_text("W"+str(world)+"-L"+str(nLevel))
	levelLabel.set_text("L"+str(nLevel))
	levelLabel.show()
	scoreLabel.set_text("Score: 0")
	scoreLabel.show()
	highscoreLabel.set_text("Highscore: " + str(world_highscores[world - 1][nLevel - 1]))
	highscoreLabel.show()
	messageLabel.set_text("Flip the coins!")
	messageLabel.show()
	update_gameTimerLabel(GameGlobals.BASE_GAME_TIME)
	gameTimerLabel.show()
	fondo.show()
	_on_StartButton_pressed()
	


func prep_game(initScore,message,gameTime,scrOneStar,scrTwoStars,scrThreeStars):
	scrOneStarAct    = scrOneStar
	scrTwoStarsAct   = scrTwoStars
	scrThreeStarsAct = scrThreeStars
	print(str(scrOneStarAct))
	print(str(scrTwoStarsAct))
	print(str(scrThreeStarsAct))
	update_score(initScore)
	show_message(message)
	init_game_timer(gameTime)
	PMMainMenuButton.set_position(POS_INI_MM_BUTTON)
	PMLevelMenuButton.set_position(POS_INI_LM_BUTTON)
	PMLevelMenuButton.show()
	PMNextLevelButton.hide()
	nextRankLabel.hide()
	#game_music.stop()
	game_music.play()

func init_game_timer(gameTime):
	update_playtime(gameTime)

func hideHUD():
	.hideHUD()
	levelLabel.hide()


func show_stars(cantStars):
	scoreStars.update_stars_cant(cantStars)
	scoreStars.show_stars_anim()
	scoreStarsTimer.start()

func hide_stars():
	scoreStars.hide_stars()

func show_game_over(world,nLevel, score): #cuando termina la partida al finalizar el playtime
	pauseButton.hide()
	game_music.stop()
	var lastCantStars = calculate_cantStars(score)
	
	if score > world_highscores[world - 1][nLevel - 1]:
		update_highscore(world,nLevel, score)
		if(haveSurpasedCantStarsMessage(world,nLevel, lastCantStars)): #los yields solo funcionan con codigo en su mismo nivel de ejecución
			yield(messageTimer, "timeout")
		surpasedHighscoreMessage(world, nLevel, score, lastCantStars)
		yield(messageTimer, "timeout")
	
	showScoreStarsPauseMenu(lastCantStars, world, nLevel)

func showScoreStarsPauseMenu(lastCantStars, world, nLevel):
	pauseMenu.show()
	PMButtons.hide()
	
	show_stars(lastCantStars)
	yield(scoreStarsTimer, "timeout")
	
	
	
	PMStartButton.set_text("Restart")
	PMStartButton.show()
	PMMainMenuButton.show()
	PMResumeButton.hide()
	
	if world_cantStars[world - 1][nLevel - 1] > 0 and nLevel < GameGlobals.CANT_LEVELS:
		PMNextLevelButton.show()
	
	
	
	if lastCantStars < 3:
		if(scrToNextStar == 1):
			nextRankLabel.set_text("To next rank: " + str( scrToNextStar) + " point ")
		else:
			nextRankLabel.set_text("To next rank: " + str( scrToNextStar) + " points ")
		nextRankLabel.show()
		
		nextRankLabelTimer.start()
		yield(nextRankLabelTimer, "timeout")
	
	PMButtons.show()


func surpasedHighscoreMessage(world, nLevel, score, lastCantStars):
	messageTimer.set_wait_time(2.5)
	show_message("Congratulations!!\n\nNew record")
	highscoreLabel.set_text("Highscore: " + str(world_highscores[world - 1][nLevel - 1]))

func haveSurpasedCantStarsMessage(world,nLevel, lastCantStars):
	var cantStarsAnt = world_cantStars[world - 1][nLevel - 1]
	if(lastCantStars > cantStarsAnt):
		update_cantStars(world,nLevel, lastCantStars)
		if(cantStarsAnt == 0 and nLevel < GameGlobals.CANT_LEVELS):
			messageTimer.stop()
			messageTimer.set_wait_time(1.5)
			show_message("Level " + str(nLevel + 1) + " unlocked!!")
			
			return true
		else:
			return false
		
	else:
		return false

func _on_StartButton_pressed():
	._on_StartButton_pressed()
	hide_stars()
	emit_signal("start_game")

func _on_LevelMenuButton_pressed():
	goBackToLSMenu()

func goBackToLSMenu():
	game_music.stop()
	hide_stars()
	eliminate_coins()
	get_tree().set_pause(false)
	GameGlobals.setPaused(false)
	#hideHUD()
	emit_signal("back_to_level_select_menu")

func init_HS_CS():
	#highscore_endless = Persistance.load_data_highscore_endless()
	world_highscores.resize(GameGlobals.CANT_WORLDS)
	world_cantStars.resize(GameGlobals.CANT_WORLDS)
	for i in range(GameGlobals.CANT_WORLDS):
		world_highscores[i] = Persistance.load_data_highscores(i)
		world_cantStars[i]  = Persistance.load_data_cantStars(i)

func update_highscore(world,level,cant):
	world_highscores[world - 1] [level - 1] = cant
	Persistance.update_highscore(world,level,cant)

func update_cantStars(world,level,cant):
	world_cantStars[world - 1][level - 1] = cant
	Persistance.update_cantStars(world,level,cant)

func eliminate_coins():
	emit_signal("stop_game")

func update_score(score):
	scoreLabel.set_text("Score: " + str(score))


func calculate_cantStars(score): #tambien hace update al scrToNextStar
	if score >= scrThreeStarsAct:
		return 3
	elif score >= scrTwoStarsAct:
		scrToNextStar =  scrThreeStarsAct - score
		return 2
	elif score >= scrOneStarAct:
		scrToNextStar =  scrTwoStarsAct - score
		return 1
	else: 
		scrToNextStar =  scrOneStarAct - score
		return 0


