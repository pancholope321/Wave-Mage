extends Node

@export var consumable_container:VBoxContainer

func load_consumables():
	var children=consumable_container.get_children()
	for child in children:
		child.queue_free()
	
