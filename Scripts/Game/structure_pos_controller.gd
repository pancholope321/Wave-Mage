extends Node2D

var test_json={
"unlocked_powers":{
	"mirror":1,
	"duplicatePower":2
	},
"power_activations":{
	"mirror":0,
	"duplicatePower":0
	},
"power_utilities":{
	"mirror":{},
	"duplicatePower":{}
	}
}
var enemy_json={
"enemy_count":{
	"enemy1":3
	}
}
@export var debug=false

@export var waveController:Node2D

func _ready() -> void:
	var file_path = "user://my_file.txt"
	var structure_path="res://ConfigFiles/structure_information_relation.json"
	var structureJson=load_json_config(structure_path)
	if check_file_exists(file_path) and !debug:
		print("File exists!")
		var final_json=load_json_config(file_path)
		waveController.create_list_of_powers(enemy_json.enemy_count,final_json.unlocked_powers,structureJson.power_player_functions)
	else:
		waveController.create_list_of_powers(enemy_json.enemy_count,test_json.unlocked_powers,structureJson.power_player_functions)
		print("File does not exist!")
		
		
	pass


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
	file.close()
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	if parse_result != OK:
		push_error("JSON Parse Error: " + json.get_error_message() + " at line " + str(json.get_error_line()))
		return null
	return json.data


func save_json_config(object, path):
	var user_dir = OS.get_user_data_dir()
	var file_path = user_dir + path+ "/buffs.json"
	# Create a FileAccess object for writing
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
