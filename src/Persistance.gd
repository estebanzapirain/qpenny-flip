extends Node

const PATH = "user://data.dat"
const PASS = "abc123"

var is_loaded = false

var data = {
	"highscores" : [],  #puntaje maximo por nivel
	"cantStars"  : []   #cantidad de estrellas maxima por nivel
}


func _ready():
	var file = File.new()
	
	if file.file_exists(PATH):
		init_data()
		load_data_highscores()
		load_data_cantStars()
		save_data()
	else:
		init_data()
		save_data()

func init_data():
	data["highscores"].resize(QPFGlobals.CANT_LEVELS)
	data["cantStars"].resize(QPFGlobals.CANT_LEVELS)
	for i in range(QPFGlobals.CANT_LEVELS):
		data["highscores"][i] = 0
		data["cantStars"][i]  = 0


func update_highscore(level,cant):
	data["highscores"][level - 1] = cant
	save_data()

func update_cantStars(level,cant):
	data["cantStars"][level - 1] = cant
	save_data()

func save_data():
	var file = File.new()
	
	file.open_encrypted_with_pass(PATH, File.WRITE, PASS)
	file.store_var(data)
	file.close()
	
	is_loaded = false


func load_data_highscores():
	return load_data("highscores")

func load_data_cantStars():
	return load_data("cantStars")

func load_data(dataIdStr):
	if is_loaded:
		return data[dataIdStr]
	
	var file = File.new()
	
	file.open_encrypted_with_pass(PATH, File.READ, PASS)
	data = file.get_var()
	file.close()
	
	is_loaded = true
	return data[dataIdStr]

