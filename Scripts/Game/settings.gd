extends Control

@onready var musicVol = $"PanelContainer/VBoxContainer/Music Volume" 
@onready var sfxVol = $"PanelContainer/VBoxContainer/SFX Volume" 
@onready var startBtn = $"../Camera2D/Start Button" 
@onready var continueBtn = $"../Camera2D/continue Button"

func _ready() -> void:
	#get_tree().paused = true 
	#visible = false 
	pass

func save_settings():
	print("saving settings") 
	Sfx.play("NeutralButtonPress", true)
	Global.save_json_config() 
	startBtn.visible = true
	continueBtn.visible = true
	visible = false
