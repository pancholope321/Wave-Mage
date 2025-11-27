extends Node2D 

@onready var player = $"Music Player"
@onready var settings = $"Settings Popup" 
@onready var startBtn = $"Camera2D/Start Button"

var menuTheme = preload("res://Sound/Music/Wavemage battle theme main loop.wav")

# Called when the node enters the scene tree for the first time.
func _ready() -> void: 
	#player.volume_db = (Global.musicVolumeSettings/100)*12
	player.stream = menuTheme 
	player.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#player.volume_db = (Global.musicVolumeSettings/100)*12
	pass

func start_game():
	get_tree().change_scene_to_file("res://Scenes/fightScene.tscn")

func display_settings(): 
	#settings.get_tree().paused = false
	settings.visible = true 
	startBtn.visible = false
