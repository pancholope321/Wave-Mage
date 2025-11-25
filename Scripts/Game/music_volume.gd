extends Control

@onready var raiseButton = $"Plus Button" 
@onready var lowerButton = $"Minus Button" 
@onready var volDisplay = $"Volume Display" 
@onready var audPlayer = $"../../Music Player"

var volume : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	volume = Global.musicVolumeSettings
	volDisplay.text = str(floor(volume)) 

func update_volume(): 
	Global.musicVolumeSettings = volume
	volDisplay.text = str(floor(volume)) 
	audPlayer.volume_db = (Global.musicVolumeSettings/100)*12

func volume_up(): 
	if (volume<100):
		volume += 1 
		update_volume()

func volume_down(): 
	if (volume>0):
		volume -= 1
		update_volume()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
