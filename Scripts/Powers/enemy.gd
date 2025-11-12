extends Node

#apply damage to the enemy is surface area times damage
func enemy(container,start,end,context):
	print("enemy")
	print("start: ",start)
	print("end: ",end)
	var vector=start.position - end.position
	var distance=abs(vector.length())
	var damageMult=(start.damage+end.damage)/200.0
	var damage=damageMult*distance
	return damage
