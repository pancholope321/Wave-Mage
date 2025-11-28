extends Area2D


@export var health=10.0
@export var waveController:Node2D
@export var waveStart:Node2D
@export var max_health=10.0
@export var player_hp_bar:TextureProgressBar
func _ready() -> void:
	max_health=health

func take_damage(damage):
	health-=damage
	if health<=0:
		Sfx.play("EnemyPlayerFaint",true)
		waveController.fight_lost()
		print("death")
	Sfx.play("EnemyPlayerTakeDamage",true)
	player_hp_bar.value=2.0+93.0*(health/max_health)

func get_wave_start():
	return waveStart
