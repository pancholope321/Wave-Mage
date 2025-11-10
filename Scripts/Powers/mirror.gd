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
	var start_wave_position=(start.position + end.position)/2.0
	var damage=(start.damage+end.damage)/2.0
	var start_position=start.position
	var end_position=end.position
	var angle_ray_1= reflect_angle_in_mirror(start_position, end_position, start.angle)
	var angle_ray_2= reflect_angle_in_mirror(start_position, end_position, end.angle)
	var order=container.get_structures_between_directions(end,angle_ray_2,start,angle_ray_1,damage)
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
	var order=container.get_structures_between_directions(end,angle_ray_2,start,angle_ray_1,damage,inverted)
	var beam= await container.paint_ordered_walls_square(order)
	
	var total_damage=await container.processDamage(beam)
	#var total_damage=0
	return total_damage


func reflect_angle_in_mirror(start_pos: Vector2, end_pos: Vector2, incident_angle: float) -> float:
	# Calculate mirror's normal vector (perpendicular to mirror surface)
	var mirror_vector = end_pos - start_pos
	var mirror_angle = mirror_vector.angle()
	
	# Calculate mirror's normal angle (perpendicular to mirror surface)
	var normal_angle = mirror_angle + PI/2  # 90 degrees counterclockwise
	
	# Calculate angle of incidence relative to mirror normal
	var incident_relative = incident_angle - normal_angle
	
	# Reflect the angle (law of reflection: angle of incidence = angle of reflection)
	var reflected_relative = -incident_relative
	
	# Convert back to global angle
	var reflected_angle = reflected_relative + normal_angle
	
	# Normalize the angle to be between -PI and PI
	reflected_angle = fmod(reflected_angle, 2 * PI)
	if reflected_angle > PI:
		reflected_angle -= 2 * PI
	elif reflected_angle < -PI:
		reflected_angle += 2 * PI
	
	return reflected_angle
