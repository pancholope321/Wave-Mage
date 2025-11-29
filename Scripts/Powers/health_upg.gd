extends Node

func add_more_health(context):
	print("adding health to player")
	context.player.max_health+=10
	context.player.health+=10
	context.player.healing()
	var key="health_upg"
	Global.gameDataDict["unlocked_powers"][key]-=1
	Global.playerStats["max_health"]+=10
	Global.playerStats["health"]+=10
	
	return
