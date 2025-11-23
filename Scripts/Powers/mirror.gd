extends Node

# nothing function
func mirror(container,start,end,context):
	print("context: ",context)
	if context.has("mirror_inverted"):
		if context.mirror_inverted:
			return await mirror_inv(container,start,end)
	print("mirror")
	print("start: ",start)
	print("end: ",end)
	if start.position.y<start.start_position.y:
		return 0
	var order_activation=start.order_activation
	var start_wave_position=(start.position + end.position)/2.0
	var damage=(start.damage+end.damage)/2.0
	var start_position=start.position
	var end_position=end.position
	var angle_ray_1= reflect_angle_in_mirror(start_position, end_position, start.angle)
	var angle_ray_2= reflect_angle_in_mirror(start_position, end_position, end.angle)
	var inverted=false
	var order=container.get_structures_between_directions(end,angle_ray_2,start,angle_ray_1,damage,inverted,order_activation)
	print("mirrror order ----------------")
	print(order)
	print("mirrror order ----------------")
	
	var beam= await container.paint_ordered_walls_square(order)
	
	var total_damage=await container.processDamage(beam)
	return total_damage


func mirror_inv(container,start,end):
	print("mirror_inverted")
	print("start: ",start)
	print("end: ",end)
	if start.position.y>start.start_position.y:
		return 0
	var start_wave_position=(start.position + end.position)/2.0
	var damage=(start.damage+end.damage)/2.0
	var start_position=start.position
	var end_position=end.position
	var angle_ray_1= reflect_angle_in_mirror(start_position, end_position, start.angle)
	var angle_ray_2= reflect_angle_in_mirror(start_position, end_position, end.angle)
	var inverted=true
	var order_activation=start.order_activation
	var order=container.get_structures_between_directions(end,angle_ray_2,start,angle_ray_1,damage,inverted,order_activation)
	var beam= await container.paint_ordered_walls_square(order)
	
	var total_damage=await container.processDamage(beam)
	#var total_damage=0
	return total_damage


func reflect_angle_in_mirror(start_pos: Vector2, end_pos: Vector2, incident_angle: float) -> float:
	# Calculate mirror angle
	var mirror_vector = end_pos - start_pos
	var mirror_angle = mirror_vector.angle()
	
	# Calculate angle between incident ray and mirror surface
	var angle_to_mirror = incident_angle - mirror_angle
	
	# Reflect across mirror surface
	var reflected_angle_relative = -angle_to_mirror
	
	# Convert back to global coordinates
	var reflected_angle = reflected_angle_relative + mirror_angle
	
	# Normalize angle
	reflected_angle = atan2(sin(reflected_angle), cos(reflected_angle))
	
	return reflected_angle
