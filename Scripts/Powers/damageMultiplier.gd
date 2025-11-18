extends Node

# nothing function
func damageMultiplier(container,start,end,context):
	print("context: ",context)
	print("damageMultiplier")
	print("start: ",start)
	print("end: ",end)
	var order_activation=start.order_activation
	var start_wave_position=(start.position + end.position)/2.0
	var damage=2.0*(start.damage+end.damage)/2.0
	var start_position=start.position
	var end_position=end.position
	var inverted=false
	var vertical=true
	var order=container.get_structures_between_directions(start,start.angle,end,end.angle,damage,inverted,order_activation,vertical)
	var beam= await container.paint_ordered_walls_square(order)
	var total_damage=await container.processDamage(beam)
	return total_damage
