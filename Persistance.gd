extends Node

const PATH = "user://data.dat"
const PASS = "abc123"

const DEFAULT_IS_MUTED = false
const DEFAULT_HS_ENDLESS = 0

const DEFAULT_HS_WORLDS = [0,0,0]
const DEFAULT_CS_WORLDS = [0,0,0]

var is_loaded = false

var data = { }


func _ready():
	
	var file = File.new()
	
	if file.file_exists(PATH):
		load_data_from_file()
#		init_data() #all values must be initialized in case something is not saved yet
#		load_data_highscores(1) #tienen que cargar algo
#		#load_data_cantStars(1)
#		save_data()
#	else:
#		init_data()
#		save_data()
	#all_levels_unlocked() #testing purposes

func all_levels_unlocked():
	for i in range(GameGlobals.CANT_WORLDS):
		for j in range(GameGlobals.CANT_LEVELS):
			data["cantStars_w" + str(i + 1)][j]  = 1
	save_data()
	is_loaded = true

func init_data():
	create_data()
	for i in range(1, GameGlobals.CANT_WORLDS + 1): #1,2,3
		data["highscores_w" + str(i)] = array_of_same_values(DEFAULT_HS_WORLDS[i - 1],GameGlobals.CANT_LEVELS)
		data["cantStars_w" + str(i)]  = array_of_same_values(DEFAULT_CS_WORLDS[i - 1],GameGlobals.CANT_LEVELS)

func create_data():
	data["highscore_endless"] = DEFAULT_HS_ENDLESS
	data["is_muted"] = DEFAULT_IS_MUTED
	for i in range(1, GameGlobals.CANT_WORLDS + 1): #1,2,3
		data["highscores_w" + str(i)] = []
		data["cantStars_w" + str(i)] = []
		data["highscores_w" + str(i)].resize(GameGlobals.CANT_LEVELS)
		data["cantStars_w" + str(i)].resize(GameGlobals.CANT_LEVELS)

func update_highscore(world,level,cant):
	data["highscores_w" + str(world)][level - 1] = cant
	save_data()

func update_array_HS(world,arrayHS):
	data["highscores_w" + str(world)] = arrayHS
	save_data()

func update_cantStars(world,level,cant):
	data["cantStars_w" + str(world)][level - 1] = cant
	save_data()

func update_array_CS(world,arrayCS):
	data["cantStars_w" + str(world)] = arrayCS
	save_data()

func update_highscore_endless(cant):
	data["highscore_endless"] = cant
	save_data()

func update_is_muted(cond):
	data["is_muted"] = cond
	save_data()

func save_data():
	var file = File.new()
	
	file.open_encrypted_with_pass(PATH, File.WRITE, PASS)
	file.store_var(data)
	file.close()
	
	is_loaded = false


func load_data_highscore_endless():
	if(!data.has("highscore_endless") ):
		update_highscore_endless(DEFAULT_HS_ENDLESS)
	return load_data("highscore_endless")

func load_data_highscores(nWorld):
	if(!data.has("highscores_w" + str(nWorld)) ):
		update_array_HS(nWorld, array_of_same_values(DEFAULT_HS_WORLDS[nWorld - 1], GameGlobals.CANT_LEVELS))
	
	return load_data("highscores_w" + str(nWorld))

func load_data_cantStars(nWorld):
	if(!data.has("cantStars_w" + str(nWorld))):
		update_array_CS(nWorld, array_of_same_values(DEFAULT_CS_WORLDS[nWorld - 1], GameGlobals.CANT_LEVELS))
	
	return load_data("cantStars_w" + str(nWorld))


func load_is_muted():
	if(!data.has("is_muted") ):
		update_is_muted(DEFAULT_IS_MUTED)
	
	return load_data("is_muted")

func array_of_same_values(value, cant):
	var array = []
	
	array.resize(cant)
	
	for i in range(cant):
		array[i] = value
	
	return array


func load_data(dataIdStr):
	if is_loaded:
		return data[dataIdStr]
	
	load_data_from_file()
	
	#data.has ( var key ) to check before consulting data to prevent no entry error
	return data[dataIdStr]

func load_data_from_file():
	var file = File.new()
	
	file.open_encrypted_with_pass(PATH, File.READ, PASS)
	data = file.get_var()
	file.close()
	
	is_loaded = true


