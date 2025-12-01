extends HBoxContainer

var description=""
var name_power=""
func set_texture(texture):
	$TextureRect.texture=texture
	$TextureRect.size.x=clamp($TextureRect.size.x,0,10)

func set_quantity_label(quant_set):
	$Label.text=str(roundi(quant_set))+":"

func set_name_label(name_set):
	name_power=name_set
	print("name_power: ",name_power)

func set_description(description_set):
	description=description_set


@export var tooltip_scene: PackedScene

var tooltip_instance: Control
var is_mouse_over: bool = false

func _ready():
	# Connect mouse signals
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	

func _process(_delta):
	if is_mouse_over and tooltip_instance:
		# Update tooltip position to follow mouse
		tooltip_instance.update_position(get_global_mouse_position())

func _on_mouse_entered():
	is_mouse_over = true
	
	# Create tooltip if it doesn't exist
	if not tooltip_instance and tooltip_scene:
		tooltip_instance = tooltip_scene.instantiate()
		get_tree().root.add_child(tooltip_instance)
	
	# Show tooltip
	if tooltip_instance:
		tooltip_instance.show_tooltip(name_power, description, get_global_mouse_position())

func _on_mouse_exited():
	is_mouse_over = false
	
	# Hide tooltip
	if tooltip_instance:
		tooltip_instance.hide_tooltip()

func _exit_tree():
	# Clean up tooltip when element is removed
	if tooltip_instance:
		tooltip_instance.queue_free()
