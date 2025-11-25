extends Node2D 

@onready var coinDisplay = $Camera2D/Coins 
@export var powersContainer: VBoxContainer
@export var powerButtonTemplate:PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	coinDisplay.text = str(int(Global.totalCoins))
	update_power_buttons()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spend(cost):
	Global.totalCoins -= cost 
	coinDisplay.text = Global.totalCoins

func update_power_buttons():
	var list_of_buyable_elements=Global.attrLvlDict["unlocked_powers"].keys()
	for child in powersContainer.get_children():
		for button in child.get_children():
			button.queue_free()
		for i in range(2):
			var random_index = randi() % list_of_buyable_elements.size()
			var rand_element = list_of_buyable_elements[random_index]
			list_of_buyable_elements.remove_at(random_index)
			var instance=powerButtonTemplate.instantiate()
			child.add_child(instance)
			instance.set_item(rand_element)
			instance.connect("pressed",add_element_to_list.bind(rand_element))
			instance.size_flags_horizontal=Control.SIZE_EXPAND_FILL
			instance.size_flags_vertical=Control.SIZE_EXPAND_FILL
			#powersContainer.size_flags_horizontal=Control.SIZE_EXPAND_FILL

func add_element_to_list(elementName):
	Global.attrLvlDict["unlocked_powers"][elementName]=(Global.attrLvlDict["unlocked_powers"][elementName])+1


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/fightScene.tscn")
