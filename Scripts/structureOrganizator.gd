extends Area2D

@export var point1:Area2D
@export var point2:Node2D
@onready var my_sprite = $Sprite2D
@export var horizontal=false
@export var mirror=false
@export var inverted=false
@export var mobile=true
var id=-1
var is_dragging=false
var mouse_offset=Vector2(0,0)
var waveStartingPoint=Vector2(576,324)
var player:Area2D
var topLeft=Vector2(0,0)
var topRight=Vector2(500,0)
var bottomLeft=Vector2(0,500)
var bottomRight=Vector2(500,500)

# Store drag start position
var drag_start_position = Vector2(0,0)

func setup_wave_starting_point(player_set):
	waveStartingPoint=player_set.get_wave_start().global_position
	player=player_set

func setup_wave_bounding_area(topLeft_set,topRight_set,bottomLeft_set,bottomRight_set):
	topLeft=topLeft_set.global_position
	topRight=topRight_set.global_position
	bottomLeft=bottomLeft_set.global_position
	bottomRight=bottomRight_set.global_position
	var overlapping=true
	var tries=6
	while overlapping and tries>0:
		var randX=randf()
		var randY=randf()
		var set_position=randY*(randX*topLeft+(1-randX)*topRight)+(1-randY)*(randX*bottomLeft+(1-randX)*bottomRight)
		self.global_position=constrain_to_bounds(set_position)
		print(global_position)
		overlapping=check_power_overlaps()
		print("overlapping: ",overlapping)
		tries-=1
	if self.global_position.y > waveStartingPoint.y:
		inverted = false
		my_sprite.flip_v = false
	else:
		inverted = true
		my_sprite.flip_v = true
	
var listOfPowers=[]
func setup_list_of_powers(listOfPowers_set):
	listOfPowers=listOfPowers_set

func setup_id(id_set):
	id=id_set

func _ready() -> void:
	mouse_offset=(point1.position+point2.position)/2.0
	# Add to group for easier identification
	add_to_group("power_structures")
	
	# Make sure monitoring is enabled and set up proper collision detection
	monitoring = true
	monitorable = true
	
	# Connect the area_entered signal for debug


func get_two_points():
	if mirror and !inverted:
		return [point2,point1]
	return [point1,point2]

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if !event.is_pressed() and is_dragging:
			# Drag ended - check for overlaps
			is_dragging = false
			# Wait a frame for physics to update
			await get_tree().process_frame
			check_power_overlaps()

func check_power_overlaps():
	var overlapping_areas = get_overlapping_areas()
	
	var is_overlapping= overlapping_areas.size()>0
	if is_overlapping:
		# Return to original position
		global_position = drag_start_position
		print("Cannot place structure - overlapping another power")
		return true
	else:
		# Structure placed successfully
		print("Structure placed successfully - no overlaps")
		return false

func _input_event(viewport, event, shape_idx):
	if !mobile:
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			get_viewport().set_input_as_handled()
			is_dragging = true
			drag_start_position = global_position  # Store original position
			mouse_offset = global_position - get_global_mouse_position()
			print("Drag started from position: ", drag_start_position)

func _process(delta):
	if is_dragging:
		var new_position = get_global_mouse_position() + mouse_offset
		
		# Constrain within bounding area
		new_position = constrain_to_bounds(new_position)
		
		global_position = new_position
		
		if mirror:
			if self.global_position.y > waveStartingPoint.y:
				inverted = false
				my_sprite.flip_v = false
			else:
				inverted = true
				my_sprite.flip_v = true

func constrain_to_bounds(position: Vector2) -> Vector2:
	var constrained_pos = position
	
	# Calculate the base bounding rectangle from your corner points
	var min_x = min(topLeft.x, bottomLeft.x)
	var max_x = max(topRight.x, bottomRight.x)
	var min_y = min(topLeft.y, topRight.y)
	var max_y = max(bottomLeft.y, bottomRight.y)
	
	# Get the node's collision shape size
	var node_size = $CollisionShape2D.shape.get_rect().size
	
	# Shrink the bounds by half the node size on each axis
	# This ensures the entire node stays inside the bounds
	if horizontal:
		max_x -= node_size.x
		min_y +=node_size.y/2.0
		max_y -= node_size.y/2.0
	else:
		max_x -= node_size.x/2.0
		min_x +=node_size.x/2.0
		max_y -= node_size.y
	
	# Constrain position
	constrained_pos.x = clamp(constrained_pos.x, min_x, max_x)
	constrained_pos.y = clamp(constrained_pos.y, min_y, max_y)
	
	return constrained_pos

func get_context():
	if mirror:
		return {"mirror_inverted": inverted}
	else:
		return {}

func playSFX():
	if mirror:
		Sfx.play("Mirror")
	else:
		Sfx.play("Duplicator")
