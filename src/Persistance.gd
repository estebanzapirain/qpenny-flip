extends Node

const PATH = "user://data.dat"
const PASS = "abc123"

const DEFAULT_LAST_VOLUME = 100
const DEFAULT_HS_ENDLESS = 0

const DEFAULT_HS_WORLDS = [0,0,0]
const DEFAULT_CS_WORLDS = [0,0,0]

var is_loaded = false

var data = { }


func _ready():
	
	var file = File.new()
	
	if file.file_exists(PATH):
		init_data() #all values must be initialized in case something is not saved yet
		#load_data_highscores(1) #tienen que cargar algo
		#load_data_cantStars(1)
		#save_data()
	else:
		init_data()
		save_data()
	#all_levels_unlocked() #testing purposes

func all_levels_unlocked():
	for i in range(QPFGlobals.CANT_WORLDS):
		for j in range(QPFGlobals.CANT_LEVELS):
			data["cantStars_w" + str(i)][j]  = 1
	save_data()
	is_loaded = true

func init_data():
	create_data()
	for i in range(1, QPFGlobals.CANT_WORLDS + 1): #1,2,3
		data["highscores_w" + str(i)] = array_of_same_values(DEFAULT_HS_WORLDS[i - 1],QPFGlobals.CANT_LEVELS)
		data["cantStars_w" + str(i)]  = array_of_same_values(DEFAULT_CS_WORLDS[i - 1],QPFGlobals.CANT_LEVELS)

func create_data():
	data["highscore_endless"] = DEFAULT_HS_ENDLESS
	data["last_volume"] = DEFAULT_LAST_VOLUME
	for i in range(1, QPFGlobals.CANT_WORLDS + 1): #1,2,3
		data["highscores_w" + str(i)] = []
		data["cantStars_w" + str(i)] = []
		data["highscores_w" + str(i)].resize(QPFGlobals.CANT_LEVELS)
		data["cantStars_w" + str(i)].resize(QPFGlobals.CANT_LEVELS)

func update_highscore(world,level,cant):
	data["highscores_w" + str(world)][level - 1] = cant
	save_data()

func update_cantStars(world,level,cant):
	data["cantStars_w" + str(world)][level - 1] = cant
	save_data()

func update_highscore_endless(cant):
	data["highscore_endless"] = cant
	save_data()

func update_last_volume(cant):
	data["last_volume"] = cant
	save_data()

func save_data():
	var file = File.new()
	
	file.open_encrypted_with_pass(PATH, File.WRITE, PASS)
	file.store_var(data)
	file.close()
	
	is_loaded = false


func load_data_highscore_endless():
	if(data.has("highscore_endless") ):
		return load_data("highscore_endless")
	else:
		return DEFAULT_HS_ENDLESS

func load_data_highscores(nWorld):
	if(data.has("highscores_w" + str(nWorld)) ):
		return load_data("highscores_w" + str(nWorld))
	else:
		return array_of_same_values(DEFAULT_HS_WORLDS[nWorld - 1], QPFGlobals.CANT_LEVELS)

func load_data_cantStars(nWorld):
	if(data.has("cantStars_w" + str(nWorld))):
		return load_data("cantStars_w" + str(nWorld))
	else:
		return array_of_same_values(DEFAULT_CS_WORLDS[nWorld - 1], QPFGlobals.CANT_LEVELS)


func load_last_volume():
	if(data.has("last_volume") ):
		return load_data("last_volume")
	else:
		return DEFAULT_LAST_VOLUME

func array_of_same_values(value, cant):
	var array = []
	
	array.resize(cant)
	
	for i in range(cant):
		array[i] = value
	
	return array


func load_data(dataIdStr):
	if is_loaded:
		return data[dataIdStr]
	
	var file = File.new()
	
	file.open_encrypted_with_pass(PATH, File.READ, PASS)
	data = file.get_var()
	file.close()
	
	is_loaded = true
	#data.has ( var key ) to check before consulting data to prevent no entry error
	return data[dataIdStr]

