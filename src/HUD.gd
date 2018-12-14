signal start_game
signal back_to_menu
signal stop_game
signal next_level

extends CanvasLayer


const INI_X_LS_BT = 40
const INC_X_LS_BT = 235
const INI_Y_LS_BT = 570
const INC_Y_LS_BT = 130

var highscores = []
var cantStars  = []

var scrOneStarAct
var scrTwoStarsAct
var scrThreeStarsAct
var scrToNextStar
var maxCantStarsAct


func _ready():
    init_HS_CS()
    get_node("ScoreStars").show()
    hideHUD()
    get_node("Game_music").set_loop(true)

func init_HS_CS():
	highscores = Persistance.load_data_highscores()
	cantStars  = Persistance.load_data_cantStars()

func update_highscore(level,cant):
	highscores[level - 1] = cant
	Persistance.update_highscore(level,cant)

func update_cantStars(level,cant):
	cantStars[level - 1] = cant
	Persistance.update_cantStars(level,cant)

func hideHUD():
    get_node("PauseMenu").hide()
    get_node("PauseButton").hide()
    get_node("HighscoreLabel").hide()
    get_node("ScoreLabel").hide()
    get_node("MessageLabel").hide()
    get_node("GameTimerLabel").hide()

func showHUD(nLevel):
    get_node("PauseMenu/NextLevelButton").hide()
    get_node("ScoreLabel").set_text("Score: 0")
    get_node("ScoreLabel").show()
    get_node("HighscoreLabel").set_text("Higscore: " + str(highscores[nLevel - 1]))
    get_node("HighscoreLabel").show()
    get_node("MessageLabel").set_text("Flip the coins!")
    get_node("MessageLabel").show()
    get_node("GameTimerLabel").set_text("Time: " + str(QPFGlobals.BASE_GAME_TIME) )
    get_node("GameTimerLabel").show()
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
    get_node("Game_music").play()


func show_message(text):
    get_node("MessageLabel").set_text(text)
    get_node("MessageLabel").show()
    get_node("MessageTimer").start()

func show_game_over(nLevel, score): #cuando termina la partida al finalizar el playtime
    QPFGlobals.setPaused(true)
    get_node("PauseButton").hide()
    get_node("Game_music").stop()
    var lastCantStars = calculate_cantStars(score)
    if score > highscores[nLevel - 1]:
        update_highscore(nLevel, score)
        var cantStarsAnt = cantStars[nLevel - 1]
        if(lastCantStars > cantStarsAnt):
            update_cantStars(nLevel, lastCantStars)
            if(cantStarsAnt == 0 and nLevel < QPFGlobals.CANT_LEVELS):
                show_message("Level " + str(nLevel + 1) + " unlocked!!")
                yield(get_node("MessageTimer"), "timeout")
        get_node("MessageTimer").set_wait_time(2.5)
        show_message("Congratulations!!\n\nNew record")
        get_node("HighscoreLabel").set_text("Higscore: " + str(highscores[nLevel - 1]))
        yield(get_node("MessageTimer"), "timeout")
        get_node("MessageTimer").set_wait_time(1.5)
    show_stars(lastCantStars)
    yield(get_node("ScoreStarsTimer"), "timeout")
    get_node("PauseMenu/StartButton").set_text("Restart")
    get_node("PauseMenu/StartButton").show()
    get_node("PauseMenu/MainMenuButton").show()
    get_node("PauseMenu/ResumeButton").hide()
    if cantStars[nLevel - 1] > 0 and nLevel < QPFGlobals.CANT_LEVELS:
        get_node("PauseMenu/NextLevelButton").show()
    
    get_node("PauseMenu").show()
    
    if lastCantStars < 3:
        get_node("MessageLabel").set_text("To next rank: " + str( scrToNextStar) + " pts. ")
        get_node("MessageLabel").show()
    

func calculate_cantStars(score):
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

func show_stars(cantStars):
	get_node("ScoreStars").update_stars_cant(cantStars)
	get_node("ScoreStars").show_stars_anim()
	get_node("ScoreStarsTimer").start()

func hide_stars():
	get_node("ScoreStars").hide_stars()

func update_score(score):
    get_node("ScoreLabel").set_text("Score: " + str(score))

func update_playtime(playtime):
    get_node("GameTimerLabel").set_text("Time: " + str(playtime))

func _on_MessageTimer_timeout():
    get_node("MessageLabel").hide()


func _on_StartButton_pressed():
    get_node("Game_music").set_paused(false)
    get_node("Game_music").stop()
    QPFGlobals.setLevel_starting(true)
    hide_stars()
    eliminate_coins()
    get_tree().set_pause(false)
    QPFGlobals.setPaused(false)
    get_node("PauseMenu").hide()
    get_node("PauseButton").show()
    emit_signal("start_game")

func _on_MainMenuButton_pressed(): 
    get_node("Game_music").set_paused(false)
    get_node("Game_music").stop()
    QPFGlobals.set_actual_screen(QPFGlobals.SCREEN_TYPES.INITIAL_MENU)
    hide_stars()
    eliminate_coins()
    get_tree().set_pause(false)
    QPFGlobals.setPaused(false)
    hideHUD()
    emit_signal("back_to_menu")
    
func eliminate_coins():
    emit_signal("stop_game")


func init_game_timer(gameTime):
    update_playtime(gameTime)




func _on_PauseButton_pressed():
    get_node("Game_music").set_paused(true)
    get_tree().set_pause(true)
    QPFGlobals.setPaused(true)
    get_node("PauseButton").hide()  
    get_node("PauseMenu/StartButton").set_text("Restart")  
    get_node("PauseMenu/ResumeButton").show()
    get_node("PauseMenu").show()
    


func _on_ResumeButton_pressed():
    get_node("Game_music").set_paused(false)
    get_node("PauseMenu").hide()
    get_node("PauseButton").show()  
    get_tree().set_pause(false)
    get_node("PauseMenu/PausedGlobalTimer").start()
    

func _on_PausedGlobalTimer_timeout():
    QPFGlobals.setPaused(false)


func _on_NextLevelButton_pressed():
	QPFGlobals.setPaused(false)
	_on_MainMenuButton_pressed()
	emit_signal("next_level")
