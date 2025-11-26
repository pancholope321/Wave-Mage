extends Control

@onready var musicVol = $"Music Volume" 

func save_settings():
	print("saving settings")
	Global.save_json_config()
	visible = false 
	set_process(false)
