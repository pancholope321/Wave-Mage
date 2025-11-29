extends Button
var key=""
var context={}
var wave_controller=null
func add_context(context_set,key_set,wave_controller_set):
	context=context_set
	key=key_set
	wave_controller=wave_controller_set
	setup_names_and_description(key)

func _on_pressed() -> void:
	Global.gameDataDict["unlocked_powers"][key]-=1
	var path_function=wave_controller.power_file_relation[key]
	var functionName = key
	var script = load(path_function).new()
	script.call(functionName,context)
	if Global.gameDataDict["unlocked_powers"][key]<=0:
		self.queue_free()
	load_label_text()

@export var quant_consumable:Label
@export var texture_rect:TextureRect
func load_label_text():
	var quantity=Global.gameDataDict["unlocked_powers"][key]
	quant_consumable.text=str(roundi(quantity))
	texture_rect.texture=load(image_path)

@export var tooltip_scene: PackedScene

var tooltip_instance: Control
var is_mouse_over: bool = false
var name_power=""
var description=""
var image_path=""
func setup_names_and_description(key):
	var dict_info=Global.inforPowerDict
	name_power=dict_info["power_name"][key]
	description=dict_info["power_description"][key]
	image_path=dict_info["power_image"][key]
	load_label_text()

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
	
