extends Control


@onready var volDisplay = $Volume 
@onready var slider = $Slider
#@onready var audPlayer = $"../../Music Player"

@export var bus : String
var volume : float 
var busIndex : int=-1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	volume = Global.gameDataDict["settings"][bus]
	slider.value = volume
	volDisplay.text = str(floori(volume)) 
	busIndex = AudioServer.get_bus_index(bus)

func update_volume(): 
	if busIndex==-1:
		return
	print("updaing volume")
	print("volume: ",volume)
	Global.gameDataDict["settings"][bus] = volume
	volDisplay.text = str(floori(volume)) 
	print("audioserver master volume: ")
	var master_index=AudioServer.get_bus_index("Master")
	print("master_index: ",master_index)
	print(AudioServer.get_bus_volume_db(master_index))
	print("bus name: ",bus)
	print("bus index: ",busIndex)
	print(AudioServer.get_bus_volume_db(busIndex))
	if (Global.gameDataDict["settings"][bus]>0): 
		AudioServer.set_bus_mute(busIndex, false)
		print("audioserver volume: ",Global.gameDataDict["settings"][bus])
		print("busindex: ",busIndex)
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
