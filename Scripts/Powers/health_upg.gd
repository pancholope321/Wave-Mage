extends Node

func add_more_health(context):
	context.player.max_health+=10
	context.player.health+=10
	context.player.healing()
	var key="health_upg"
	print("Global.gameDataDict: ",Global.gameDataDict)
	print("Global.gameDataDict: ",Global.gameDataDict)
	var difference=Global.gameDataDict["unlocked_powers"][key]-Global.gameDataDict["power_activations"][key]
	for i in range(difference):
		Global.playerStats["max_health"]+=10
		Global.playerStats["health"]+=10
		Global.gameDataDict["power_activations"][key]+=1
	return
