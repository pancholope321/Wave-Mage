extends Area2D

@export var point1:Area2D
@export var point2:Node2D
@export var horizontal=false
@export var mirror=false
var is_dragging=false
var mouse_offset=Vector2(0,0)

func _ready() -> void:
	mouse_offset=(point1.position+point2.position)/2.0
	
func get_two_points():
	return [point1,point2]


func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			is_dragging = true
			mouse_offset = global_position - get_global_mouse_position()
			#initial_position = global_position
		elif event.is_released():
			is_dragging = false

func _process(delta):
	if is_dragging:
		global_position = get_global_mouse_position() + mouse_offset
