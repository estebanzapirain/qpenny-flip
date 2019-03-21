signal start_game
signal start_game_endless
signal back_to_main_menu
signal back_to_level_select_menu
signal stop_game
signal stop_game_endless
signal next_level

extends CanvasLayer


const INI_X_LS_BT = 40
const INC_X_LS_BT = 235
const INI_Y_LS_BT = 570
const INC_Y_LS_BT = 130

const POS_INI_LM_BUTTON = Vector2(341,921)
const POS_INI_MM_BUTTON = Vector2(341,1045)

var world_highscores = []
var world_cantStars  = []
var highscore_endless

var scrOneStarAct
var scrTwoStarsAct
var scrThreeStarsAct
var scrToNextStar
var maxCantStarsAct

var in_endless_Mode = false

var nWorldAct 



func _ready():
    init_HS_CS()
    get_node("ScoreStars").show()
    hideHUD()
    get_node("Game_music").set_loop(true)

func setMessageFontColors(color): #r, g and b are values in [0;1] range
	get_node("ScoreLabel").add_color_override("font_color",color)
	get_node("HighscoreLabel").add_color_override("font_color",color)
	get_node("GameTimerLabel").add_color_override("font_color",color)
	get_node("MessageLabel").add_color_override("font_color",color)
	get_node("PauseMenu/StartButton").add_color_override("font_color",color)
	get_node("PauseMenu/ResumeButton").add_color_override("font_color",color)
	get_node("PauseMenu/NextLevelButton").add_color_override("font_color",color)
	get_node("PauseMenu/LevelMenuButton").add_color_override("font_color",color)
	get_node("PauseMenu/MainMenuButton").add_color_override("font_color",color)
	
	changePauseButtonColor( color )

func changePauseButtonColor( color ):
		get_node("PauseButton").changeColor(color) #change sprite color 
	                                             #to change properly must be originally white 
	                                             #also changes the child nodes color
	                                             #self_modulate to change only that node


func init_HS_CS():
	highscore_endless = Persistance.load_data_highscore_endless()
	world_highscores.resize(QPFGlobals.CANT_WORLDS)
	world_cantStars.resize(QPFGlobals.CANT_WORLDS)
	for i in range(QPFGlobals.CANT_WORLDS):
		world_highscores[i] = Persistance.load_data_highscores(i)
		world_cantStars[i]  = Persistance.load_data_cantStars(i)

func update_highscore(world,level,cant):
	world_highscores[world - 1] [level - 1] = cant
	Persistance.update_highscore(world,level,cant)

func update_cantStars(world,level,cant):
	world_cantStars[world - 1][level - 1] = cant
	Persistance.update_cantStars(world,level,cant)

func hideHUD():
    get_node("PauseMenu").hide()
    get_node("PauseButton").hide()
    get_node("HighscoreLabel").hide()
    get_node("ScoreLabel").hide()
    get_node("MessageLabel").hide()
    get_node("GameTimerLabel").hide()
    get_node("Fondo").hide()

func showHUD(world,nLevel):
    get_node("PauseMenu/NextLevelButton").hide()
    get_node("ScoreLabel").set_text("Score: 0")
    get_node("ScoreLabel").show()
    get_node("HighscoreLabel").set_text("Higscore: " + str(world_highscores[world - 1][nLevel - 1]))
    get_node("HighscoreLabel").show()
    get_node("MessageLabel").set_text("Flip the coins!")
    get_node("MessageLabel").show()
    get_node("GameTimerLabel").set_text("Time: " + str(QPFGlobals.BASE_GAME_TIME) )
    get_node("GameTimerLabel").show()
    get_node("Fondo").show()
    in_endless_Mode = false
    _on_StartButton_pressed()

func showHudEndlessMode():
	get_node("PauseMenu/NextLevelButton").hide()
	get_node("ScoreLabel").set_text("Time: 0")
	get_node("ScoreLabel").show()
	get_node("HighscoreLabel").set_text("Higscore: " + str(highscore_endless) )
	get_node("HighscoreLabel").show()
	get_node("MessageLabel").set_text("Flip the coins!")
	get_node("MessageLabel").show()
	get_node("Fondo").setColorFondo(1)
	get_node("Fondo").show()
	setMessageFontColors(get_node("Fondo").getColorComplementario() )
	in_endless_Mode = true
	_on_StartButton_pressed()
   

func cambiaColorLevel(nLevel):
	var intNLevel = int(nLevel)
	var fracNLevel = nLevel - intNLevel
	get_node("Fondo").setColorFondo(1 + fracNLevel + intNLevel % int(QPFGlobals.CANT_LEVELS * float(5) / 4 )) #% QPFGlobals.CANT_LEVELS)
	setMessageFontColors(get_node("Fondo").getColorComplementario() )

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
	get_node("PauseMenu/MainMenuButton").set_pos(POS_INI_MM_BUTTON)
	get_node("PauseMenu/LevelMenuButton").set_pos(POS_INI_LM_BUTTON)
	get_node("PauseMenu/LevelMenuButton").show()
	get_node("PauseMenu/NextLevelButton").hide()
	get_node("Game_music").play()

func prep_endless_game(initScore, message, cantLives):
	update_endless_score(initScore)
	show_message(message)
	get_node("GameTimerLabel").set_text("Lives: " + str(cantLives) )
	get_node("GameTimerLabel").show()
	get_node("PauseMenu/NextLevelButton").hide()
	get_node("PauseMenu/LevelMenuButton").hide()
	get_node("PauseMenu/MainMenuButton").set_pos(POS_INI_LM_BUTTON)
	get_node("Game_music").play()


func update_endless_score(cant):
	get_node("ScoreLabel").set_text("Time: " + str(cant))

func update_endless_lives(lives):
	get_node("GameTimerLabel").set_text("Lives: " + str(lives) )

func show_message(text):
    get_node("MessageLabel").set_text(text)
    get_node("MessageLabel").show()
    get_node("MessageTimer").start()

func show_game_over(world,nLevel, score): #cuando termina la partida al finalizar el playtime
    get_node("PauseButton").hide()
    QPFGlobals.set_actual_screen(QPFGlobals.GAME_ENDING)
    get_node("Game_music").stop()
    var lastCantStars = calculate_cantStars(score)
    if score > world_highscores[world - 1][nLevel - 1]:
        update_highscore(world,nLevel, score)
        var cantStarsAnt = world_cantStars[world - 1][nLevel - 1]
        if(lastCantStars > cantStarsAnt):
            update_cantStars(world,nLevel, lastCantStars)
            if(cantStarsAnt == 0 and nLevel < QPFGlobals.CANT_LEVELS):
                show_message("Level " + str(nLevel + 1) + " unlocked!!")
                yield(get_node("MessageTimer"), "timeout")
        get_node("MessageTimer").set_wait_time(2.5)
        show_message("Congratulations!!\n\nNew record")
        get_node("HighscoreLabel").set_text("Higscore: " + str(world_highscores[world - 1][nLevel - 1]))
        yield(get_node("MessageTimer"), "timeout")
        get_node("MessageTimer").set_wait_time(1.5)
    show_stars(lastCantStars)
    yield(get_node("ScoreStarsTimer"), "timeout")
    get_node("PauseMenu/StartButton").set_text("Restart")
    get_node("PauseMenu/StartButton").show()
    get_node("PauseMenu/MainMenuButton").show()
    get_node("PauseMenu/ResumeButton").hide()
    if world_cantStars[world - 1][nLevel - 1] > 0 and nLevel < QPFGlobals.CANT_LEVELS:
        get_node("PauseMenu/NextLevelButton").show()
    
    get_node("PauseMenu").show()
    
    if lastCantStars < 3:
        get_node("MessageLabel").set_text("To next rank: " + str( scrToNextStar) + " pts. ")
        get_node("MessageLabel").show()

    QPFGlobals.set_actual_screen(QPFGlobals.GAME_ENDED)

func show_game_over_endless(timeAchieved): #cuando termina la partida al finalizar el playtime
	get_node("PauseButton").hide()
	QPFGlobals.set_actual_screen(QPFGlobals.GAME_ENDING_ENDLESS)
	get_node("Game_music").stop()
	
	if timeAchieved > highscore_endless:
		Persistance.update_highscore_endless(timeAchieved)
		highscore_endless = timeAchieved
		get_node("MessageTimer").set_wait_time(2.5)
		show_message("Congratulations!!\n\nNew record")
		get_node("HighscoreLabel").set_text("Higscore: " + str(highscore_endless))
		yield(get_node("MessageTimer"), "timeout")
		get_node("MessageTimer").set_wait_time(1.5)
	get_node("PauseMenu/StartButton").set_text("Restart")
	get_node("PauseMenu/StartButton").show()
	get_node("PauseMenu/MainMenuButton").show()
	get_node("PauseMenu/ResumeButton").hide()
	
	get_node("PauseMenu").show()
	
	QPFGlobals.set_actual_screen(QPFGlobals.GAME_ENDED_ENDLESS)
    
func update_highscore_endless(timeAchieved):
	highscore_endless = timeAchieved

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
	eliminate_coins()
	get_tree().set_pause(false)
	QPFGlobals.setPaused(false)
	get_node("PauseMenu").hide()
	get_node("PauseButton").show()
	if(in_endless_Mode):
		emit_signal("start_game_endless")
	else:
		hide_stars()
		emit_signal("start_game")

func _on_LevelMenuButton_pressed():
	get_node("Game_music").set_paused(false)
	get_node("Game_music").stop()
	QPFGlobals.set_actual_screen(QPFGlobals.SCREEN_TYPES.LEVEL_SELECT)
	hide_stars()
	eliminate_coins()
	get_tree().set_pause(false)
	QPFGlobals.setPaused(false)
	hideHUD()
	emit_signal("back_to_level_select_menu")

func _on_MainMenuButton_pressed(): 
	get_node("Game_music").set_paused(false)
	get_node("Game_music").stop()
	QPFGlobals.set_actual_screen(QPFGlobals.SCREEN_TYPES.INITIAL_MENU)
	hide_stars()
	eliminate_coins()
	get_tree().set_pause(false)
	QPFGlobals.setPaused(false)
	hideHUD()
	emit_signal("back_to_main_menu")
    
func eliminate_coins():
	if(!in_endless_Mode):
		emit_signal("stop_game")
	else:
		emit_signal("stop_game_endless")


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
	_on_LevelMenuButton_pressed()
	emit_signal("next_level")



