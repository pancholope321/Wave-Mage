extends Node

# nothing function
func poison_dmg(container,start,end,context):
	print("context: ",context)
	print("poison_dmg")
	print("start: ",start)
	print("end: ",end)
	var order_activation=start.order_activation
	var start_wave_position=(start.position + end.position)/2.0
	var damage=(start.damage+end.damage)/2.0
	var poison=(start.damage+end.damage)/2.0
	print("poison_added to the poison_dmg: ",poison)
	var start_position=start.position
	var end_position=end.position
	var inverted=false
	var vertical=true
	var color=Color(0.5,1,0.5)
	var init_start=start.duplicate()
	init_start.poison_dmg=poison
	var order=container.get_structures_between_directions(init_start,start.angle,end,end.angle,damage,inverted,order_activation,color,vertical)
	var beam= await container.paint_ordered_walls_square(order)
	var total_damage=await container.processDamage(beam)
	return total_damage
