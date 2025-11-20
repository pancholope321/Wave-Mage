extends Node2D

@onready var coinTotalLabel = $"Camera2D/Coin Total" 
var coins = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	coinTotalLabel.text = Global.totalCoins

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass 

"""func add_up_coins():
	pass""" 



func replay():
	get_tree().change_scene_to_file("res://Scenes/fightScene.tscn") 

func to_shop(): 
	get_tree().change_scene_to_file("res://Scenes/shopScene.tscn") 

func main_menu():
	get_tree().change_scene_to_file("res://Scenes/mainMenu.tscn")
