extends Node

@export var start_music:AudioStreamPlayer
@export var music_loop:AudioStreamPlayer

func _ready() -> void:
	start_music.connect("finished",start_loop)
	start_music.play()

func start_loop():
	music_loop.play()
