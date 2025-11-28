extends Node2D

@onready var coinTotalLabel = $"Camera2D/Coin Total" 
var coins = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	coinTotalLabel.text = "0"
	tween_coins_won()
	Global.totalCoins["playing"]=false
	Global.save_json_config()


func main_menu():
	get_tree().change_scene_to_file("res://Scenes/mainMenu.tscn")


func tween_coins_won():
	var tween=create_tween()
	tween.tween_method(textConverterformNumber.bind(coinTotalLabel),0,Global.totalCoins["money"],1.0)

func textConverterformNumber(number,element):
	element.text=str(round(number))
