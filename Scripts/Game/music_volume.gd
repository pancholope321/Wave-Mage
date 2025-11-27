extends Control

@onready var raiseButton = $"Plus Button" 
@onready var lowerButton = $"Minus Button" 
@onready var volDisplay = $"Volume Display" 
@onready var audPlayer = $"../../Music Player"

var volume : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	volume = Global.settings["music_volume"]
	volDisplay.text = str(floor(volume)) 

func update_volume(): 
	Global.settings["music_volume"] = volume
	volDisplay.text = str(floor(volume)) 
	audPlayer.volume_db = (Global.settings["music_volume"]/100)*12

func volume_up(): 
	if (volume<100):
		volume += 1 
		update_volume()

func volume_down():
	print("volume_down")
	if (volume>0):
		volume -= 1
		update_volume()

# Called every frame. 'delta' is the elapsed time since the previous frame.
