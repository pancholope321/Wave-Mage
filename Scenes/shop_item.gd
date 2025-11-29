extends Button

var itemName=null
@export var level : int 
@export var isUpgrade : bool
@export var labelPrice :Label
@export var texture: TextureRect
@export var texture_price_cont=TextureRect
var price=3
# Called when the node enters the scene tree for the first time.
var name_power=""
var description=""
func set_item(nameItem):
	itemName=nameItem 
	level = Global.gameDataDict["unlocked_powers"][itemName]
	var power_relations=Global.inforPowerDict
	var priceDict=power_relations["power_costs"][itemName]
	print("priceDict: ",priceDict)
	price=priceDict["price"]+level*priceDict["growth_per_level"]
	labelPrice.text = str(roundi(price))
	var image=Global.inforPowerDict["power_image"][itemName]
	var loaded_image=load(image)
	texture.texture=loaded_image
	name_power=power_relations["power_name"][itemName]
	description=power_relations["power_description"][itemName]

func updatePrice():
	level = Global.gameDataDict["unlocked_powers"][itemName] 
	var priceDict=Global.inforPowerDict["power_costs"][itemName]
	price=priceDict["price"]+level*priceDict["growth_per_level"]
	labelPrice.text = str(roundi(price))

func get_price():
	return roundi(self.price)


func _ready() -> void:
	$AnimationPlayer.seek(randf_range(0,8))
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func disable_button():
	self.disabled=true
	texture.texture=null
	texture_price_cont.texture=load("res://Sprites/Shop Sprites/sold.png")
	labelPrice.text = ""

@export var tooltip_scene: PackedScene

var tooltip_instance: Control
var is_mouse_over: bool = false


	

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
