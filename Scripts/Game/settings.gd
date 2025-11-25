extends Control

@onready var musicVol = $"Music Volume" 

var settingsDict : Dictionary

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	settingsDict = {
		"music_volume":Global.musicVolumeSettings
	}


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func save_settings(): 
	settingsDict["music_volume"] = Global.musicVolumeSettings
	var game_data = Global.load_game_data() 
	game_data["settings"]["music_volume"] = settingsDict["music_volume"]
	Global.save_json_config(game_data)
	visible = false 
	set_process(false)
