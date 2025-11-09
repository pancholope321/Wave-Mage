extends Node

# here we need to apply the duplicate wave function, logic comes next
func duplicatePower(container,start,end):
	print("duplicate")
	print("start: ",start)
	print("end: ",end)
	var start_wave_position=(start.position + end.position)/2.0
	var angle=20
	var damage=(start.damage+end.damage)/2.0
	var order=container.get_structures_in_angle(start_wave_position,angle,damage)
	
	var beam= await container.paint_ordered_walls(order)
	print("beams_duplicator: ",beam)
	var total_damage=await container.processDamage(beam)
	#return total_damage
	return total_damage
