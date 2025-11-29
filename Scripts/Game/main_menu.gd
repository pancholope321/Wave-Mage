extends Node2D 

@onready var settings = $"Settings Popup" 
@onready var startBtn = $"Camera2D/Start Button" 
@onready var shopBtn = $"Camera2D/continue Button"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#player.volume_db = (Global.musicVolumeSettings/100)*12
	pass

func start_game(): 
	Sfx.play("PositiveButtonPress", true)
	Global.load_new_game()
	get_tree().change_scene_to_file("res://Scenes/fightScene.tscn") 

func continue_game():
	Sfx.play("PositiveButtonPress", true) 
	get_tree().change_scene_to_file("res://Scenes/shopScene.tscn") 

func display_settings(): 
	#settings.get_tree().paused = false
	Sfx.play("NeutralButtonPress", true)
	settings.visible = true 
	startBtn.visible = false 
	shopBtn.visible = false
