extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass 

func add_up_coins():
	pass

func replay():
	get_tree().change_scene_to_file("res://Scenes/fightScene.tscn") 

func to_shop(): 
	get_tree().change_scene_to_file("res://Scenes/shopScene.tscn") 

func main_menu():
	get_tree().change_scene_to_file("res://Scenes/mainMenu.tscn")
