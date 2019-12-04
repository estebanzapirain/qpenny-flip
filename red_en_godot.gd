extends Node

# Connection constants
#const HOST = "192.168.109.43"
const HOST = "gti.fi.mdp.edu.ar"
const PORT = 80
const BASIC_HEADERS = ["User-Agent: PDTZ_2D/1.0", "Accept: */*"]

const DIR_NAME = "Datos encuesta QPF"
const FILE_NAME = "encuesta.dat"

#const FILE_NAME = "user://events.save"

var filePath

# Connection variables
var http = null
var is_connected = false

func _ready():
	updateSaveFilePathFromOS()
	checkCreateFile()

#to get the external storage path from OS
func updateSaveFilePathFromOS():
	
	var dirPath = OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS)
	var dir = Directory.new()
	dir.open(dirPath)
	dir.make_dir(DIR_NAME)
	filePath = dirPath + "/" + DIR_NAME + "/" +FILE_NAME

func checkCreateFile():
	var save_game = File.new()
	if(save_game.open(filePath, File.READ_WRITE) != 0):
		save_game.open(filePath, File.WRITE)
	save_game.close()


func init_network():
	http = HTTPClient.new()
	http.connect_to_host(HOST, PORT)
	# Wait until resolved and connected
	while http.get_status() == HTTPClient.STATUS_CONNECTING or http.get_status() == HTTPClient.STATUS_RESOLVING:
		http.poll()
		OS.delay_msec(50)
	# Connection result
	var status = http.get_status()
	# Disconnected from the server
	if status == HTTPClient.STATUS_DISCONNECTED:
		print("Network disconnected")
	# DNS failure: Can’t resolve the hostname for the given URL
	elif status == HTTPClient.STATUS_CANT_RESOLVE:
		print("Network cant resolve")
	# Can’t connect to the server
	elif status == HTTPClient.STATUS_CANT_CONNECT:
		print("Network cant connect")
	# Error in HTTP connection
	elif status == HTTPClient.STATUS_CONNECTION_ERROR:
		print("Network connection error")
	# Error in SSL handshake
	elif status == HTTPClient.STATUS_SSL_HANDSHAKE_ERROR:
		print("Network ssl handshake error")
	# Connection established
	elif status == HTTPClient.STATUS_CONNECTED:
		is_connected = true
		#print("Connection success")

func postHttp(query):
	init_network()
	if is_connected:
	    #this is not necesary if the info is sent in String
		query = http.query_string_from_dict(query)
		var headers = BASIC_HEADERS
		headers.append("Content-Type: application/x-www-form-urlencoded")
		headers.append("Content-Length: " + str(query.length()))
		http.request(http.METHOD_POST, "/qpf/eventsreceiver.php", headers, query)
		# Keep polling until the request is going on
		while http.get_status() == HTTPClient.STATUS_REQUESTING:
			http.poll()
			OS.delay_msec(50)
		
		print("se mando nomas")

func appendToFile(query):
	var save_game = File.new()
	save_game.open(filePath, File.READ_WRITE)
	save_game.seek_end()
	save_game.store_line(to_json(query))
	save_game.close()
	



func _send_event(rta1, rta2, rta3, rta4, rta5):
	appendToFile({
		"RTA1": rta1,
		"RTA2": rta2,
		"RTA3": rta3,
		"RTA4": rta4,
		"RTA5": rta5})
	return postHttp({
		"RTA1": rta1,
		"RTA2": rta2,
		"RTA3": rta3,
		"RTA4": rta4,
		"RTA5": rta5})


