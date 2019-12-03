signal start_game
signal stop_game

extends "HUD.gd"

onready var infinitySprite = $InfinitySprite
onready var livesLabel = $LivesLabel

var highscore

# Called when the node enters the scene tree for the first time.
func _ready():
	init_Highscore()


func init_Highscore():
	highscore = Persistance.load_data_highscore_endless()

func setMessageFontColors(color): #r, g and b are values in [0;1] range
	.setMessageFontColors(color)
	infinitySprite.set_modulate(color)
	livesLabel.add_color_override("font_color",color)

func hideHUD():
	.hideHUD()
	infinitySprite.hide()
	livesLabel.hide()

func showHud():
	infinitySprite.show()
	scoreLabel.set_text("Time: 0")
	scoreLabel.show()
	highscoreLabel.set_text("Highscore: " + str(highscore) )
	highscoreLabel.show()
	messageLabel.set_text("Flip the coins!")
	messageLabel.show()
	fondo.setColorFondo(1)
	fondo.show()
	setMessageFontColors(fondo.getColorComplementario() )
	_on_StartButton_pressed()


func prep_game(initScore, message, cantLives):
	update_score(initScore)
	show_message(message)
	livesLabel.set_text("Lives: " + str(cantLives) )
	livesLabel.show()
	PMMainMenuButton.set_position(POS_INI_LM_BUTTON)
	game_music.play()


func update_score(cant):
	scoreLabel.set_text("Time: " + str(cant))

func update_lives(lives):
	livesLabel.set_text("Lives: " + str(lives) )


func show_game_over(timeAchieved): #cuando termina la partida al finalizar el playtime
	pauseButton.hide()
	game_music.stop()
	
	if timeAchieved > highscore:
		surpasedHighscore(timeAchieved)
		yield(messageTimer, "timeout") #los yields solo funcionan con codigo en su mismo nivel de ejecución
		messageTimer.set_wait_time(1.5)
	
	PMStartButton.set_text("Restart")
	PMStartButton.show()
	PMMainMenuButton.show()
	PMResumeButton.hide()
	
	pauseMenu.show()
	

func surpasedHighscore(timeAchieved):
	Persistance.update_highscore_endless(timeAchieved)
	highscore = timeAchieved
	messageTimer.set_wait_time(2.5)
	show_message("Congratulations!!\n\nNew record")
	highscoreLabel.set_text("Highscore: " + str(highscore))
	


func _on_StartButton_pressed():
	._on_StartButton_pressed()
	emit_signal("start_game")

func game_over():
	emit_signal("stop_game")

func update_highscore_endless(timeAchieved):
	highscore = timeAchieved