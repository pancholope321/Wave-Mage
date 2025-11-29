extends Node

# nothing function
func health_potion(context):
	print("health_potion")
	var healing=15
	Sfx.play("NeutralButtonPress")
	context.player.health=clamp(context.player.health+healing,0,context.player.max_health)
	context.player.healing()
	return 0
