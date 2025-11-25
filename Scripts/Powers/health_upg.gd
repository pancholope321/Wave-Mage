extends Node

func add_more_health(context):
	print("adding health to player")
	context.player.max_health+=100
	context.player.health+=100
	return
