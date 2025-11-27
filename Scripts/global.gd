extends Node
# we need to add functions to have data permanence, 
# lets use the json on the config files
# ConfigFiles>player_statistics>json 
var defaultData = "res://ConfigFiles/player_statistics.json" 
 
var playerStats : Dictionary

var gameDataDict : Dictionary
var inforPowerDict: Dictionary
var settings : Dictionary 

var musicIdx = AudioServer.get_bus_index("Music")
var sfxIdx = AudioServer.get_bus_index("SFX")

var coinsWon=0 

#Ready function
func _ready() -> void: 
	gameDataDict = load_game_data()
	settings = gameDataDict["settings"]
	
	playerStats = gameDataDict["player_stats"]
	
	inforPowerDict=load_json_config("res://ConfigFiles/structure_information_relation.json")

	AudioServer.set_bus_volume_db(musicIdx, db_converter(gameDataDict["settings"]["Music"])) 
	AudioServer.set_bus_volume_db(sfxIdx, db_converter(gameDataDict["settings"]["SFX"]))
	

#Other functions 

"""
This function performs calculations on the input volume percentage and converts it to a reasonable 
decibel value. E.g. At 100% volume, the music will be 6db.
"""
func db_converter(input):
	return (input/100)*10-4

func load_new_game():
	var def_data=load_json_config(defaultData)
	var copy_settings=settings.duplicate()
	gameDataDict=def_data
	gameDataDict["settings"]=copy_settings
	settings = gameDataDict["settings"]
	playerStats = gameDataDict["player_stats"]
	save_json_config()


func load_game_data(): 
	if (check_file_exists("user://wmsave.json")):
		return load_json_config("user://wmsave.json") 
	else:
		print("default data loading")
		return load_json_config(defaultData)

func check_file_exists(file_path: String) -> bool:
	return FileAccess.file_exists(file_path)

func load_json_config(file_path: String):
	if not FileAccess.file_exists(file_path):
		push_error("JSON file does not exist: " + file_path)
		return null
	var file = FileAccess.open(file_path, FileAccess.READ)
	if not file:
		push_error("Failed to open JSON file: " + file_path)
		return null
	var json_string = file.get_as_text()
	print("json string: ", json_string)
	file.close()
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	if parse_result != OK:
		push_error("JSON Parse Error: " + json.get_error_message() + " at line " + str(json.get_error_line()))
		return null
	return json.data

func save_json_config():
	print("saving json...")
	print(playerStats)
	#var user_dir = OS.get_user_data_dir()
	#var file_path = user_dir + path+ "/buffs.json"
	# Create a FileAccess object for writing 
	
	var file_path = "user://wmsave.json"
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	if file:
		# Convert your data to JSON string
		var json_string = JSON.stringify(gameDataDict)
		# Write the JSON string to file
		file.store_string(json_string)
		file.close()
	else:
		print("Error: Could not save file to path")
	return
