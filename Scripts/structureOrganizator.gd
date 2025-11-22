extends Area2D

@export var point1:Area2D
@export var point2:Node2D
@onready var my_sprite = $Sprite2D
@export var horizontal=false
@export var mirror=false
@export var inverted=false
@export var mobile=true

var is_dragging=false
var mouse_offset=Vector2(0,0)
var waveStartingPoint=Vector2(576,324)
var player:Area2D
func setup_wave_starting_point(player_set):
	waveStartingPoint=player_set.get_wave_start().global_position
	player=player_set

func _ready() -> void:
	mouse_offset=(point1.position+point2.position)/2.0
	
func get_two_points():
	if mirror and !inverted:
		return [point2,point1]
	return [point1,point2]

func _input_event(viewport, event, shape_idx):
	if !mobile:
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			# Set this as the topmost draggable object
			get_viewport().set_input_as_handled()
			is_dragging = true
			mouse_offset = global_position - get_global_mouse_position()
		elif event.is_released():
			is_dragging = false

func _process(delta):
	if is_dragging:
		global_position = get_global_mouse_position() + mouse_offset
		if mirror:
			if self.global_position.y>waveStartingPoint.y:
				inverted=false
				my_sprite.flip_v=false
			else:
				inverted=true
				my_sprite.flip_v=true

func get_context():
	if mirror:
		return {"mirror_inverted":inverted}
	else:
		return {}
