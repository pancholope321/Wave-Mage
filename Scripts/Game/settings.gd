extends Control

@onready var musicVol = $"PanelContainer/VBoxContainer/Music Volume" 
@onready var sfxVol = $"PanelContainer/VBoxContainer/SFX Volume" 
@onready var startBtn = $"../Camera2D/Start Button"

func _ready() -> void:
	#get_tree().paused = true 
	#visible = false 
	pass

func save_settings():
	print("saving settings") 
	Global.save_json_config() 
	startBtn.visible = true
	visible = false
