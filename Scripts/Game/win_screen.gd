extends Node2D

@export var coinTotalLabel:Label 
@export var coinsWonLabel :Label 
var coinsWon : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_coins()

func to_shop():
	Global.totalCoins["current_day"]+=1
	Global.save_json_config()
	get_tree().change_scene_to_file("res://Scenes/shopScene.tscn") 
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func load_coins():
	coinsWonLabel.text = "0"
	var coinsWon=Global.coinsWon
	Global.totalCoins["money"] += coinsWon
	coinTotalLabel.text = "0"
	tween_coins_won(coinsWon)
	
func tween_coins_won(coinsWon):
	var tween=create_tween()
	tween.set_parallel(true)
	tween.tween_method(textConverterformNumber.bind(coinsWonLabel),0,coinsWon,1.0)
	tween.tween_method(textConverterformNumber.bind(coinTotalLabel),0,Global.totalCoins["money"],1.0)
	#tween.tween_property(coinsWonLabel,"text",coinsWon,1.0)
	#tween.tween_property(coinTotalLabel,"text",Global.totalCoins,1.0)

func textConverterformNumber(number,element):
	element.text=str(round(number))
