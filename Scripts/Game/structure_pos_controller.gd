extends Node2D

var test_json={
"unlocked_powers":{
	"mirror":1,
	"duplicatePower":1,
	"damageMultiplier":1
	},
"power_activations":{
	"mirror":0,
	"duplicatePower":0,
	"damageMultiplier":0
	},
"power_utilities":{
	"mirror":{},
	"duplicatePower":{},
	"damageMultiplier":{}
	}
}
var enemy_json={
"enemy_count":{
	"enemy1":1,
	"enemy2":1
	}
}
@export var debug=false

@export var waveController:Node2D

func _ready() -> void:
	var file_path = "user://my_file.txt"
	var structure_path="res://ConfigFiles/structure_information_relation.json"
	var structureJson=Global.load_json_config(structure_path)
	if Global.check_file_exists(file_path) and !debug:
		print("File exists!")
		var final_json=Global.load_json_config(file_path)
		waveController.create_list_of_powers(enemy_json.enemy_count,final_json.unlocked_powers,structureJson.power_player_functions)
	else:
		waveController.create_list_of_powers(enemy_json.enemy_count,test_json.unlocked_powers,structureJson.power_player_functions)
		print("File does not exist!")
		
		
	pass
