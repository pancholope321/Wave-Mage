extends Node

#apply damage to the enemy is surface area times damage
func enemy(container,start,end):
	print("enemy")
	print("start: ",start)
	print("end: ",end)
	var vector=start.position - end.position
	var distance=vector.length()
	var damageMult=(start.damage+end.damage)/200.0
	var damage=damageMult*distance
	return damage
