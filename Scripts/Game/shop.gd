extends Control

@onready var coinDisplay = $Coins 
@export var powersContainer: HBoxContainer
@export var powerButtonTemplate:PackedScene
@export var powerList:VBoxContainer
@export var powerUITemplate:PackedScene
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	coinDisplay.text = str(int(Global.playerStats["money"]))
	update_power_buttons()
	actualize_power_list()

# Called every frame. 'delta' is the elapsed time since the previous frame.

func spend(cost):
	Global.playerStats["money"] -= cost 
	coinDisplay.text = Global.playerStats["money"]

func update_power_buttons():
	var list_of_buyable_elements=Global.gameDataDict["unlocked_powers"].keys()
	for child in powersContainer.get_children():
		child.queue_free()
	for i in range(4):
		var random_index = randi() % list_of_buyable_elements.size()
		var rand_element = list_of_buyable_elements[random_index]
		list_of_buyable_elements.remove_at(random_index)
		var instance=powerButtonTemplate.instantiate()
		powersContainer.add_child(instance)
		instance.set_item(rand_element)
		instance.connect("pressed",add_element_to_list.bind(rand_element,instance))
		instance.size_flags_horizontal=Control.SIZE_EXPAND_FILL
		instance.size_flags_vertical=Control.SIZE_EXPAND_FILL
		#powersContainer.size_flags_horizontal=Control.SIZE_EXPAND_FILL

func add_element_to_list(elementName,button):
	var button_price=button.get_price()
	print("trying to buy")
	if button_price<=Global.playerStats["money"]:
		Sfx.play("PositiveButtonPress")
		Global.gameDataDict["unlocked_powers"][elementName]=(Global.gameDataDict["unlocked_powers"][elementName])+1
		Global.playerStats["money"]-=button_price
		print("actually buying")
		button.disable_button()
		coinDisplay.text = str(int(Global.playerStats["money"]))
		actualize_power_list()

func _on_play_pressed() -> void:
	Global.save_json_config()
	get_tree().change_scene_to_file("res://Scenes/fightScene.tscn")

func _on_menu_pressed() -> void:
	Global.save_json_config()
	get_tree().change_scene_to_file("res://Scenes/mainMenu.tscn")


func _on_refresh_pressed() -> void:
	if 1<=Global.playerStats["money"]:
		Sfx.play("PositiveButtonPress")
		Global.playerStats["money"]-=1
		coinDisplay.text = str(int(Global.playerStats["money"]))
		update_power_buttons()


func actualize_power_list():
	var children=powerList.get_children()
	for child in children:
		child.queue_free()
	var power_dict=Global.gameDataDict["unlocked_powers"]
	var power_relations= Global.inforPowerDict
	var key_powers=power_dict.keys()
	for key in key_powers:
		var curr_power=power_dict[key]
		if curr_power>0:
			var instance=powerUITemplate.instantiate()
			var texture_path=power_relations["power_image"][key]
			var power_name=power_relations["power_name"][key]
			var power_description=power_relations["power_description"][key]
			instance.set_texture(load(texture_path))
			instance.set_quantity_label(curr_power)
			instance.set_name_label(power_name)
			instance.set_description(power_description)
			powerList.add_child(instance)
