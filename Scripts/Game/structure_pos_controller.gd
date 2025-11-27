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
	"goblin_spear":0,
	"goblin_arrow":0,
	"goblin_mage":1,
	"skeleton_spear":1,
	"skeleton_dagger":1
	},
	"health":10
}
@export var debug=false

@export var waveController:Node2D

func _ready() -> void:
	var file_path = "user://wmsave.json"
	var structure_path="res://ConfigFiles/structure_information_relation.json"
	var final_json=Global.attrLvlDict
	var structureJson=Global.load_json_config(structure_path)
	print("final_json: ",final_json)
	#waveController.create_list_of_powers(enemy_json.enemy_count,final_json.unlocked_powers,structureJson.power_player_functions)
	
	if Global.check_file_exists(file_path) and !debug:
		print("File exists!")
		var final_json2=Global.attrLvlDict
		enemy_json=generate_enemy_json()
		waveController.create_list_of_powers(enemy_json,final_json2.unlocked_powers,structureJson.power_player_functions)
	else:
		enemy_json=generate_enemy_json()
		waveController.create_list_of_powers(enemy_json,test_json.unlocked_powers,structureJson.power_player_functions)
		print("File does not exist!")
		
		
	pass

func generate_enemy_json():
	
	var current_day=Global.attrLvlDict["player_stats"]["current_day"]
	var enemy_json_set={
	"enemy_count":{
	"goblin_spear":0,
	"goblin_arrow":0,
	"goblin_mage":0,
	"skeleton_spear":0,
	"skeleton_dagger":0
	},
	"health":0
	}
	var number=roundi(current_day)%3+1
	print("current_dayyyyyy----------------------------------")
	print("number: ",number)
	print("current_dayyyyyy----------------------------------")
	for i in range(number):
		var rand_key=enemy_json_set["enemy_count"].keys().pick_random()
		enemy_json_set["enemy_count"][rand_key]+=1
	var health=(2.0+current_day*2)/number
	enemy_json_set["health"]=health
	return enemy_json_set
