extends Control

@onready var coinTotalLabel = $"Coin Total" 
var coins = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	coinTotalLabel.text = "0"
	tween_coins_won()
	Global.playerStats["playing"]=false
	Global.save_json_config()


func main_menu():
	Sfx.play("NegativeButtonPress")
	get_tree().change_scene_to_file("res://Scenes/mainMenu.tscn")


func tween_coins_won():
	var tween=create_tween()
	tween.tween_method(textConverterformNumber.bind(coinTotalLabel),0,Global.playerStats["money"],1.0)

func textConverterformNumber(number,element):
	element.text=str(round(number))


var full_text = "GAME OVER"
var visible_count = 0
var speed = 0.5 # characters per second

@export var character_label:Label
var forward=true
var time=0.5
func _process(delta):
	if forward:
		character_label.visible_characters_behavior=TextServer.VC_GLYPHS_LTR
		character_label.visible_ratio+=delta*time
		if character_label.visible_ratio>=0.99:
			forward=false
	else:
		character_label.visible_characters_behavior=TextServer.VC_GLYPHS_RTL
		character_label.visible_ratio-=delta*time
		if character_label.visible_ratio<=0.01:
			forward=true


func _on_wavemage_loss_cue_finished() -> void:
	var music=$"Wavemage-VictoryLossScreen"
	music.volume_db=-40
	music.play()
	var tween = create_tween()
	tween.tween_property(music,"volume_db",0,4.0)
