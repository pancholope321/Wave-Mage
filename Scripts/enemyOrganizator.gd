extends Area2D

@export var point1:Area2D
@export var point2:Node2D
@export var projectile:PackedScene
@onready var my_sprite = $Sprite2D
@export var healthBar:TextureProgressBar
@export var damage=1
var mouse_offset=Vector2(0,0)
var waveStartingPoint=Vector2(576,324)
@export var health=2.0
var max_health=2.0
var alive=true
var player:Area2D
func recieve_damage(damage):
	health-=damage
	if health<=0:
		alive=false

func activate_final_actions():
	if !alive:
		Sfx.play("EnemyPlayerFaint",true)
		self.queue_free()
	healthBar.value=5+90*(health/max_health)
	#Sfx.play("EnemyPlayerTakeDamage",true)
	#animate damage taken

func setup_wave_starting_point(player_set):
	waveStartingPoint=player_set.get_wave_start().global_position
	player=player_set

func _ready() -> void:
	mouse_offset=(point1.position+point2.position)/2.0
	max_health=health
	
func get_two_points():
	return [point1,point2]
func is_alive():
	return alive

func get_context():
	return {}

func get_attack_damage():
	return damage

func animate_enemy_attack(playerNode):
	if !alive:
		return
	var instance=projectile.instantiate()
	if player==null:
		player=playerNode
	var start_set=(self.global_position+point2.global_position)/2.0
	var end_set=player.global_position
	instance.setup_start_end(start_set,end_set)
	self.add_child(instance)
	var tween=create_tween()
	tween.tween_method(instance.launch_projectile,0.0,1.0,1.0)
	await tween.finished
	instance.end_action()
	var total_damage=get_attack_damage()
	player.take_damage(total_damage)
	
	return
var id=-1
func setup_id(index):
	id=index
func playSFX():
	Sfx.play("EnemyPlayerTakeDamage",true)

func setup_health(health_set):
	health=health_set
	max_health=health_set
