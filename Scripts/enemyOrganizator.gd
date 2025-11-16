extends Area2D

@export var point1:Area2D
@export var point2:Node2D
@onready var my_sprite = $Sprite2D

var mouse_offset=Vector2(0,0)
var waveStartingPoint=Vector2(576,324)
var health=10
var alive=true
func recieve_damage(damage):
	health-=damage
	if health<=0:
		alive=false

func activate_final_actions():
	if !alive:
		self.queue_free()

func setup_wave_starting_point(point):
	waveStartingPoint=point

func _ready() -> void:
	mouse_offset=(point1.position+point2.position)/2.0
	
func get_two_points():
	return [point1,point2]
func is_alive():
	return alive

func get_context():
	return {}
