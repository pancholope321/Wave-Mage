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
signal finish_action(self_node)
var max_health=2.0
var alive=true
var player:Area2D
var current_poison=0
var current_fire_dmg=0
var wave_controller:Node2D

func recieve_damage(damage):
	health-=damage
	health-=current_poison
	health-=current_fire_dmg
	if health<=0:
		alive=false
func get_poison_dmg(poison):
	current_poison+=poison

func get_fire_dmg(fire_dmg):
	current_fire_dmg+=fire_dmg

func activate_final_actions():
	if current_fire_dmg>0:
		current_fire_dmg-=1
		await animate_fire()
	if current_poison>0:
		current_poison-=1
		await animate_poison()
	if !alive:
		Sfx.play("EnemyPlayerFaint",true)
		emit_signal("finish_action", self)
		self.queue_free()
	healthBar.value=5+90*(health/max_health)
	emit_signal("finish_action", self)

func animate_fire():
	var animation=load("res://Particles/fire_burn.tscn")
	var instance=animation.instantiate()
	add_child(instance)
	instance.position=(point2.position)
	Sfx.play("Fire",true)
	await get_tree().create_timer(0.8).timeout
	instance.queue_free()
	await get_tree().create_timer(0.2).timeout
	return

func animate_poison():
	var animation=load("res://Particles/poison_burn.tscn")
	var instance=animation.instantiate()
	add_child(instance)
	instance.position=(point2.position)
	Sfx.play("Poison",true)
	await get_tree().create_timer(0.8).timeout
	instance.queue_free()
	await get_tree().create_timer(0.2).timeout
	return

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
@export var animator:AnimationPlayer
@export var animate_time:float=1.0
func animate_enemy_attack(playerNode):
	wave_controller=playerNode.waveController
	if !alive:
		return
	var instance=projectile.instantiate()
	if player==null:
		player=playerNode
	var start_set=(self.global_position+point2.global_position)/2.0
	var end_set=player.global_position
	instance.setup_start_end(start_set,end_set,wave_controller)
	if animator!=null and animator.has_animation("Attack"):
		animator.play("Attack")
	self.add_child(instance)
	var tween=create_tween()
	tween.tween_method(instance.launch_projectile,0.0,1.0,animate_time)
	await tween.finished
	instance.end_action(wave_controller)
	var total_damage=get_attack_damage()
	player.take_damage(total_damage)
	if animator!=null and animator.has_animation("Attack"):
		animator.play("Idle")
	return

var id=-1
func setup_id(index):
	id=index

func playSFX():
	Sfx.play("EnemyPlayerTakeDamage",true)

func setup_health(health_set):
	health=health_set
	max_health=health_set
