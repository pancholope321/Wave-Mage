extends Area2D


@export var health=100
@export var waveController:Node2D
@export var waveStart:Node2D

func take_damage(damage):
	health-=damage
	if health<=0:
		waveController.fight_lost()
		print("death")

func get_wave_start():
	return waveStart
