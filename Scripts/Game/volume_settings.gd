extends Control


@onready var volDisplay = $Volume 
@onready var slider = $Slider
#@onready var audPlayer = $"../../Music Player"

@export var bus : String
var volume : float 
var busIndex : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	volume = Global.gameDataDict["settings"][bus]
	slider.value = volume
	volDisplay.text = str(floori(volume)) 
	busIndex = AudioServer.get_bus_index(bus)

func update_volume(): 
	Global.gameDataDict["settings"][bus] = volume
	volDisplay.text = str(floori(volume)) 
	if (Global.gameDataDict["settings"][bus]>0): 
		AudioServer.set_bus_mute(busIndex, false)
		AudioServer.set_bus_volume_db(busIndex, Global.db_converter(Global.gameDataDict["settings"][bus], bus))
	else: 
		AudioServer.set_bus_mute(busIndex, true)
	#audPlayer.volume_db = (Global.musicVolumeSettings/100)*12

func change_volume(delta : float): 
	volume = slider.value 
	update_volume()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
