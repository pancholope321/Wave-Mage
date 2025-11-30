extends Node

@export var start_music:AudioStreamPlayer
@export var music_loop:AudioStreamPlayer
var initialVolume=1.0
func _ready() -> void:
	start_music.connect("finished",start_loop)
	start_music.play()
	initialVolume=Global.settings["Music"]
	AudioServer.set_bus_volume_db(1,db_converter(initialVolume,"Music"))

func start_loop():
	music_loop.play()

func attacking():
	var tween_audio=create_tween()
	tween_audio.tween_method(audio_for_tweening,initialVolume,initialVolume-40.0,1.0)
	#AudioServer.set_bus_volume_db(1,initialVolume-10.0)


func stopAttacking():
	var tween_audio=create_tween()
	tween_audio.tween_method(audio_for_tweening,initialVolume-40,initialVolume,1.0)
	#AudioServer.set_bus_volume_db(1,initialVolume)


func audio_for_tweening(volume):
	AudioServer.set_bus_volume_db(1,db_converter(volume,"Music"))

func db_converter(input, bus): 
	match bus:
		"Music":
			return ((input/100)*10-4)-((100-input)*0.25)
		"SFX":
			return ((input/100)*10-14)-((100-input)*0.25)
