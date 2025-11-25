extends Node
# we need to add functions to have data permanence, 
# lets use the json on the config files
# ConfigFiles>player_statistics>json 
var defaultData = "res://ConfigFiles/player_statistics.json" 
 
var totalCoins = 0

var attrLvlDict : Dictionary
var inforPowerDict: Dictionary
var healthUpgradePrices = [100, 200, 300, 400]

var coinsWon=0 

#Ready function
func _ready() -> void:
	print("load_game_data:", load_game_data())
	totalCoins = load_game_data()["player_stats"]["money"]
	attrLvlDict = load_game_data()
	inforPowerDict=load_json_config("res://ConfigFiles/structure_information_relation.json")
	

#Other functions

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

func save_json_config(object):
	#var user_dir = OS.get_user_data_dir()
	#var file_path = user_dir + path+ "/buffs.json"
	# Create a FileAccess object for writing 
	var file_path = "user://wmsave.json"
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	if file:
		# Convert your data to JSON string
		var json_string = JSON.stringify(object)
		# Write the JSON string to file
		file.store_string(json_string)
		file.close()
	else:
		print("Error: Could not save file to path")
	return
