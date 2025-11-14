extends Node2D

@export var wave_start:Node2D
@export var enemyPoint1:Area2D
@export var enemyPoint2:Node2D

var script_instances = {}

var Structures = []
var power_file_relation
func _ready() -> void:
	power_file_relation = await load_json_config("res://ConfigFiles/structure_file_relation.json")
	#attack(1)

var listOfPowers=[]
func create_list_of_powers(PowerJson,structureJson):
	listOfPowers=[]
	var dict = {"id":0,
		"powerName": "enemy",
		"startPos": enemyPoint1, 
		"endPos": enemyPoint2,
		"node":enemyPoint1
	}
	listOfPowers.append(dict)
	var keys=PowerJson.keys()
	var index=1
	for key in keys:
		for i in range(PowerJson[key]):
			var path=structureJson[key].structure
			var pathloaded=load(path)
			var instance=pathloaded.instantiate()
			add_child(instance)
			instance.setup_wave_starting_point(wave_start.global_position)
			var newDict={
			"id":index,
			"powerName": key,
			"startPos": instance.get_two_points()[0], 
			"endPos": instance.get_two_points()[1],
			"node":instance}
			index+=1
			listOfPowers.append(newDict)
	print("listOfPowers: ",listOfPowers)
	pass
	
	
# when attack is pressed the wave is propagating
func attack(damage,start_position=wave_start.position):
	# this are the structures that are placed on the canvas (example)
	# the powerName is the actual function name, so wall calls func wall
	#var listOfPowers=[{"id":1,"powerName": "duplicatePower",
		#"startPos": duplicator.get_two_points()[0].global_position, 
		#"endPos": duplicator.get_two_points()[1].global_position,
		#"node":duplicator},
		#{"id":2,"powerName": "wall",
		#"startPos": wall_point_3.global_position, 
		#"endPos": wall_point_4.global_position,
		#"node":wall_point_3},
		#{"id":3,"powerName": "wall",
		#"startPos": wall_point_5.global_position, 
		#"endPos": wall_point_6.global_position,
		#"node":wall_point_5},
		#{"id":4,"powerName":"mirror",
		#"startPos": mirror.get_two_points()[0].global_position, 
		#"endPos": mirror.get_two_points()[1].global_position,
		#"node":mirror},
		#{"id":5,"powerName":"mirror",
		#"startPos": mirror_point_4.global_position, 
		#"endPos": mirror_point_3.global_position,
		#"node":mirror_point_3}]
	#var dict = {"id":0,
		#"powerName": "enemy",
		#"startPos": enemyPoint1.global_position, 
		#"endPos": enemyPoint2.global_position,
		#"node":enemyPoint1
	#}
	
	#Structures.append(dict)
	Structures=[]
	for i in range(listOfPowers.size()):
		var powerAdded=listOfPowers[i]
		print("power_added ",powerAdded)
		powerAdded.startPos=powerAdded.node.get_two_points()[0].global_position
		powerAdded.endPos=powerAdded.node.get_two_points()[1].global_position
		Structures.append(listOfPowers[i])
		
			
	
	var start_wave_position = wave_start.global_position
	var order = []
	
	for structure in Structures:
		for pos in ["startPos","endPos"]:
			var vector_to_pos = structure[pos] - start_wave_position
			var angle = vector_to_pos.angle()
			var angle_degrees = rad_to_deg(angle)
			var distance = start_wave_position.distance_to(structure[pos])
			var dictOrder = {
				"start_position":start_position,
				"position":structure[pos],
				"angle": angle,
				"angle_degrees": angle_degrees,
				"distance": distance,
				"powerName": structure.get("powerName", "unknown"),
				"currentPos":pos,
				"id":structure["id"],
				"damage":damage
			}
			order.append(dictOrder)
	
	order.sort_custom(sort_by_angle_then_distance)
	print("order: ",order)
	var firstBeam=paint_ordered_walls(order)
	var totalDamage=processDamage(firstBeam)
	
	print("final totalDamange: ",totalDamage)
	
# with this function we visualize the borders of the waves
func paint_ordered_walls(order):
	var currentStructures=[]
	var activePower={"distance"=99999999}
	var currentLines=[]
	for element in order:
		if element["currentPos"]=="startPos":
			currentStructures.append(element)
			if element.distance<activePower.distance:
				if activePower.has("position"):
					var newElements=order.filter(func(x): return x.id == activePower.id)
					var nepos1=newElements[0].position
					var nepos2=newElements[1].position
					var neposang1=newElements[0].angle
					var neposang2=newElements[1].angle
					var newElementPosition=nepos2+(nepos1-nepos2)*(neposang2-element["angle"])/(neposang2-neposang1)
					var newdict=activePower.duplicate()
					newdict.position=newElementPosition
					newdict.currentPos="endPos"
					linesDrawn.append(newdict)
					currentLines.append(newdict)
				activePower=element
				linesDrawn.append(element)
				currentLines.append(element)
			else:
				continue
		elif element["currentPos"]=="endPos":
			currentStructures = currentStructures.filter(func(x): return x.id != element.id)
			print("activePower ",activePower)
			print("element ",element)
			if activePower.id==element.id:
				linesDrawn.append(element)
				currentLines.append(element)
				if currentStructures.size()>0:
					currentStructures.sort_custom(sort_by_distance)
					activePower=currentStructures[0]
					var newElements=order.filter(func(x): return x.id == activePower.id)
					var nepos1=newElements[0].position
					var nepos2=newElements[1].position
					var neposang1=newElements[0].angle
					var neposang2=newElements[1].angle
					var newElementPosition=nepos2+(nepos1-nepos2)*(neposang2-element["angle"])/(neposang2-neposang1)
					var newdict=activePower.duplicate()
					newdict.position=newElementPosition
					linesDrawn.append(newdict)
					currentLines.append(newdict)
				else:
					activePower={"distance"=99999999}
	currentLines=clearcurrentLines(currentLines)
	setupWaves(currentLines)
	return currentLines

func clearcurrentLines(currentLines):
	var finalOrder=[]
	for i in range(currentLines.size()/2):
		var x=i*2
		if (currentLines[x].position-currentLines[x+1].position).length()>0.1:
			finalOrder.append(currentLines[x])
			finalOrder.append(currentLines[x+1])
	return finalOrder

func get_structure_context(id):
	for structure in Structures:
		if structure.id == id:
			if structure.node.has_method("get_context"):
				return structure.node.get_context()
			break
	return {}


func paint_ordered_walls_square(order):
	var currentStructures = []
	var activePower = {"distance": 99999999, "id":-1}
	var currentLines = []
	# Sort order by distance first to ensure proper processing
	for element in order:
		if element["currentPos"] == "startPos":
			currentStructures.append(element)
			var elementDistance=element.distance
			var ray_source_pos = element["start_position"]
			var rayDirection=element.start_position-element.position
			var activePowerDistance=activePower.distance
			if activePower.has("position"):
				var newElements = order.filter(func(x): return x.id == activePower.id)
				var nepos1 = newElements[0].position
				var nepos2 = newElements[1].position
				var dir1=nepos1-nepos2
				var newElementPosition=instersection_pos_dir_pos_dir(ray_source_pos,rayDirection,nepos1,dir1)
				activePowerDistance=(newElementPosition-ray_source_pos).length()
			if rayDirection.length() < activePowerDistance:
				# If there was an active power, create an intermediate end point for it
				if activePower.has("position"):
					var newElements = order.filter(func(x): return x.id == activePower.id)
					if newElements.size() >= 2:
						var nepos1 = newElements[0].position
						var nepos2 = newElements[1].position
						var dir1=nepos1-nepos2
						var newElementPosition=instersection_pos_dir_pos_dir(ray_source_pos,rayDirection,nepos1,dir1)
						var newdict = activePower.duplicate()
						newdict.position = newElementPosition
						newdict.currentPos = "endPos"
						newdict.start_position = ray_source_pos  # Use the current element's start position
						linesDrawn.append(newdict)
						currentLines.append(newdict)
				activePower = element
				linesDrawn.append(element)
				currentLines.append(element)
			else:
				continue
				
		elif element["currentPos"] == "endPos":
			currentStructures = currentStructures.filter(func(x): return x.id != element.id)
			
			if activePower.id == element.id:
				linesDrawn.append(element)
				currentLines.append(element)
				
				if currentStructures.size() > 0:
					currentStructures.sort_custom(sort_by_distance)
					
					# Calculate actual distance for the new active power from current end position
					var closestPower = null
					var closestDistance = 99999999
					
					for structure in currentStructures:
						var ray_source_pos = element["position"]  # Start from current end position
						var rayDirection = element.start_position - element.position  # Use element's original direction
						
						var newElements = order.filter(func(x): return x.id == structure.id)
						if newElements.size() >= 2:
							var nepos1 = newElements[0].position
							var nepos2 = newElements[1].position
							var dir1 = nepos1 - nepos2
							var newElementPosition = instersection_pos_dir_pos_dir(ray_source_pos, rayDirection, nepos1, dir1)
							
							if newElementPosition != null:
								var actualDistance = (newElementPosition - ray_source_pos).length()
								if actualDistance < closestDistance:
									closestDistance = actualDistance
									closestPower = structure
					
					if closestPower != null:
						activePower = closestPower
						
						# Create the intersection point for the new active power
						var ray_source_pos = element["start_position"]
						var rayDirection = element.start_position - element.position
						
						var newElements = order.filter(func(x): return x.id == activePower.id)
						if newElements.size() >= 2:
							var nepos1 = newElements[0].position
							var nepos2 = newElements[1].position
							var dir1 = nepos1 - nepos2
							var newElementPosition = instersection_pos_dir_pos_dir(ray_source_pos, rayDirection, nepos1, dir1)
							
							if newElementPosition != null:
								var newdict = activePower.duplicate()
								newdict.position = newElementPosition
								newdict.currentPos = "endPos"
								newdict.start_position = ray_source_pos
								linesDrawn.append(newdict)
								currentLines.append(newdict)
					else:
						activePower = {"distance": 99999999, "id":-1}
				else:
					activePower = {"distance": 99999999, "id":-1}
	
	setupWavesSquare(currentLines)
	return currentLines



var linesDrawn=[]
func _draw():
	return
	var size=20.0
	for line in linesDrawn:
		var start_position =line.start_position
		var end_position = line.position
		var random_color = Color(randf(), randf(), randf())
		
		draw_line(start_position, end_position, random_color, size)
		size*=0.75

func setupWaves(lines):
	for i in range(lines.size() / 2):
		var start_position = lines[i * 2].start_position
		var vertix1 = lines[i * 2].position
		var vertix2 = lines[i * 2 + 1].position
		var distance = (lines[i * 2].distance + lines[i * 2 + 1].distance) / 2.0
		
		var bounds = get_triangle_bounds([start_position, vertix1, vertix2])
		
		# Make the ColorRect square to prevent stretching
		var max_size = max(bounds.size.x, bounds.size.y)
		var square_bounds = Rect2(
			bounds.position, 
			Vector2(max_size, max_size)
		)
		
		var color_rect = ColorRect.new()
		add_child(color_rect)
		color_rect.position = square_bounds.position
		color_rect.size = square_bounds.size
		color_rect.color = Color(1.0, 1.0, 1.0, 1.0)
		
		var shader_material = ShaderMaterial.new()
		shader_material.shader = preload("res://Shaders/wave_shader.gdshader")
		
		# Convert points to the square coordinate system
		var points_array = [start_position, vertix1, vertix2]
		var points_relative = []
		for point in points_array:
			points_relative.append((point - square_bounds.position) / square_bounds.size)
		
		# Calculate frequency based on the square size (consistent across all triangles)
		var base_frequency = 12.0
		#var normalized_frequency = base_frequency / (max_size / 200.0)
		
		shader_material.set_shader_parameter("triangle_points", points_relative)
		shader_material.set_shader_parameter("origin", (start_position - square_bounds.position) / square_bounds.size)
		shader_material.set_shader_parameter("wave_speed", 20.0)
		shader_material.set_shader_parameter("wave_frequency", distance/5.0)
		shader_material.set_shader_parameter("min_alpha", 0.0)
		shader_material.set_shader_parameter("max_alpha", 1.0)
		
		color_rect.material = shader_material

func setupWavesSquare(lines):
	for i in range(lines.size() / 2):
		var line1 = lines[i * 2]
		var line2 = lines[i * 2 + 1]
		
		# Calculate the four vertices of the square/quadrilateral
		var vertix1 = line1.start_position  # First ray origin
		var vertix2 = line1.position        # First ray intersection
		var vertix3 = line2.position        # Second ray intersection
		var vertix4 = line2.start_position  # Second ray origin
		
		if (vertix1 - vertix4).length() <= 1.0 and (vertix2 - vertix3).length() <= 1.0:
			continue
		# Use all four vertices for bounds calculation
		var bounds = get_square_bounds([vertix1, vertix2, vertix3, vertix4])
		
		# Make the ColorRect square to prevent stretching
		var max_size = max(bounds.size.x, bounds.size.y)
		var square_bounds = Rect2(
			bounds.position, 
			Vector2(max_size, max_size)
		)
		
		var color_rect = ColorRect.new()
		add_child(color_rect)
		color_rect.position = square_bounds.position
		color_rect.size = square_bounds.size
		color_rect.color = Color(1.0, 1.0, 1.0, 1.0)
		
		var shader_material = ShaderMaterial.new()
		shader_material.shader = preload("res://Shaders/wave_shader_square.gdshader")
		
		# Convert ALL FOUR points to the square coordinate system
		var points_array = [vertix1, vertix2, vertix3, vertix4]
		var points_relative = []
		for point in points_array:
			points_relative.append((point - square_bounds.position) / square_bounds.size)
		
		# Calculate average distance
		var avg_distance = (line1.distance + line2.distance) / 2.0
		
		# ORIGIN: Point between both start positions (ray origins)
		var origin_between_starts = (line1.start_position + line2.start_position) / 2.0
		
		shader_material.set_shader_parameter("square_points", points_relative)
		shader_material.set_shader_parameter("origin", (origin_between_starts - square_bounds.position) / square_bounds.size)
		shader_material.set_shader_parameter("wave_speed", 20.0)
		shader_material.set_shader_parameter("wave_frequency", avg_distance / 5.0)
		shader_material.set_shader_parameter("min_alpha", 0.0)
		shader_material.set_shader_parameter("max_alpha", 1.0)
		
		color_rect.material = shader_material
	
	pass

# Helper function to calculate bounds for four points
func get_square_bounds(vertices):
	var min_x = vertices[0].x
	var max_x = vertices[0].x
	var min_y = vertices[0].y
	var max_y = vertices[0].y
	
	for vertex in vertices:
		min_x = min(min_x, vertex.x)
		max_x = max(max_x, vertex.x)
		min_y = min(min_y, vertex.y)
		max_y = max(max_y, vertex.y)
	
	return Rect2(Vector2(min_x, min_y), Vector2(max_x - min_x, max_y - min_y))


func get_triangle_bounds(points: Array) -> Rect2:
	if points.size() < 3:
		return Rect2()
	
	var min_point = points[0]
	var max_point = points[0]
	
	for point in points:
		min_point.x = min(min_point.x, point.x)
		min_point.y = min(min_point.y, point.y)
		max_point.x = max(max_point.x, point.x)
		max_point.y = max(max_point.y, point.y)
	
	return Rect2(min_point, max_point - min_point)

func world_to_uv(world_pos: Vector2, bounds: Rect2) -> Vector2:
	if bounds.size.x == 0 or bounds.size.y == 0:
		return Vector2(0.5, 0.5)
	
	var uv_x = (world_pos.x - bounds.position.x) / bounds.size.x
	var uv_y = (world_pos.y - bounds.position.y) / bounds.size.y
	
	return Vector2(uv_x, uv_y)

func processDamage(firstBeam):
	var totalDamage=0
	for i in range(firstBeam.size() / 2):
		var filepath = power_file_relation[firstBeam[i*2].powerName]
		var functionName = firstBeam[i*2].powerName
		
		if not script_instances.has(filepath):
			var script = load(filepath)
			if script:
				script_instances[filepath] = script.new()
			else:
				print("Failed to load script: ", filepath)
				continue
		var context=get_structure_context(firstBeam[i*2].id)
		totalDamage += script_instances[filepath].call(functionName, self, firstBeam[i*2], firstBeam[i*2+1],context)
	return totalDamage



func sort_by_angle_then_distance(a, b):
	if a.angle != b.angle:
		return a.angle < b.angle
	else:
		return a.distance < b.distance


func sort_by_distance(a, b):
	if a.distance != b.distance:
		return a.distance < b.distance
	else:
		return a.angle < b.angle


func get_structures_in_angle(start_wave_position, angle_struct, damage):
	var min_angle = deg_to_rad(-angle_struct)  # negative angle
	var max_angle = deg_to_rad(angle_struct)   # positive angle
	var order = []
	
	for structure in Structures:
		var valid_points = []
		
		var line_start = structure["startPos"]
		var line_end = structure["endPos"]
		
		# Check if the entire structure is completely outside the angle range
		var vector_to_start = line_start - start_wave_position
		var vector_to_end = line_end - start_wave_position
		var start_angle = vector_to_start.angle()
		var end_angle = vector_to_end.angle()
		
		# Normalize angles to handle wrap-around (important!)
		start_angle = normalize_angle(start_angle)
		end_angle = normalize_angle(end_angle)
		
		# Check if structure is completely outside angle range
		var both_outside_min = start_angle < min_angle and end_angle < min_angle
		var both_outside_max = start_angle > max_angle and end_angle > max_angle
		
		if both_outside_min or both_outside_max:
			continue  # Skip this structure entirely
		
		# Find intersection points with angle boundaries
		var intersections = []
		
		# Test intersection with min angle boundary
		var min_boundary_dir = Vector2(cos(min_angle), sin(min_angle))
		var min_intersect = line_intersection(start_wave_position, start_wave_position + min_boundary_dir * 10000, line_start, line_end)
		if min_intersect and point_on_line_segment(min_intersect, line_start, line_end):
			intersections.append({"point": min_intersect, "boundary": "min"})
		
		# Test intersection with max angle boundary
		var max_boundary_dir = Vector2(cos(max_angle), sin(max_angle))
		var max_intersect = line_intersection(start_wave_position, start_wave_position + max_boundary_dir * 10000, line_start, line_end)
		if max_intersect and point_on_line_segment(max_intersect, line_start, line_end):
			intersections.append({"point": max_intersect, "boundary": "max"})
		
		# Check original points that are within the angle range
		if is_angle_in_range(start_angle, min_angle, max_angle):
			valid_points.append({
				"position": line_start,
				"currentPos": "startPos",
				"is_original": true,
				"distance_from_start": 0.0  # This is the actual start point
			})
		
		if is_angle_in_range(end_angle, min_angle, max_angle):
			valid_points.append({
				"position": line_end,
				"currentPos": "endPos", 
				"is_original": true,
				"distance_from_start": line_start.distance_to(line_end)  # This is the actual end point
			})
		
		# Add intersection points as clipped versions
		for intersection in intersections:
			var intersect_point = intersection["point"]
			var dist_from_start = line_start.distance_to(intersect_point)
			var dist_from_end = line_end.distance_to(intersect_point)
			
			# Determine which position this intersection replaces
			var current_pos = "startPos"
			if dist_from_start > dist_from_end:
				current_pos = "endPos"
			else:
				current_pos = "startPos"
			
			valid_points.append({
				"position": intersect_point,
				"currentPos": current_pos,
				"is_original": false,
				"is_clipped": true,
				"boundary": intersection["boundary"],
				"distance_from_start": dist_from_start
			})
		
		# Remove duplicate points (when original point is exactly on boundary)
		remove_duplicate_points(valid_points)
		
		# Sort points by distance from line_start to maintain segment order
		valid_points.sort_custom(func(a, b): 
			return a.get("distance_from_start", line_start.distance_to(a["position"])) < b.get("distance_from_start", line_start.distance_to(b["position"]))
		)
		
		# Ensure we have exactly 2 points for a valid segment
		if valid_points.size() >= 2:
			# Take only the first and last points to define the clipped segment
			var clipped_segment = [valid_points[0], valid_points[valid_points.size() - 1]]
			
			# FIX: Ensure we have one startPos and one endPos
			# The point closer to the original start should be startPos, the other should be endPos
			if clipped_segment.size() == 2:
				var dist1 = line_start.distance_to(clipped_segment[0]["position"])
				var dist2 = line_start.distance_to(clipped_segment[1]["position"])
				
				# The point closer to the original start becomes startPos
				if dist1 <= dist2:
					clipped_segment[0]["currentPos"] = "startPos"
					clipped_segment[1]["currentPos"] = "endPos"
				else:
					clipped_segment[0]["currentPos"] = "endPos"
					clipped_segment[1]["currentPos"] = "startPos"
			
			for point_data in clipped_segment:
				var vector_to_point = point_data["position"] - start_wave_position
				var angle = normalize_angle(vector_to_point.angle())
				var angle_degrees = rad_to_deg(angle)
				var distance = start_wave_position.distance_to(point_data["position"])
				
				var dictOrder = {
					"start_position": start_wave_position,
					"position": point_data["position"],
					"angle": angle,
					"angle_degrees": angle_degrees,
					"distance": distance,
					"powerName": structure.get("powerName", "unknown"),
					"currentPos": point_data["currentPos"],  # This should now be correct
					"id": structure["id"],
					"damage": damage
				}
				
				if point_data.get("is_clipped", false):
					dictOrder["is_clipped"] = true
				
				order.append(dictOrder)
	order.sort_custom(sort_by_angle_then_distance)
	return order

# Keep all your helper functions the same...
func normalize_angle(angle):
	while angle > PI:
		angle -= 2 * PI
	while angle < -PI:
		angle += 2 * PI
	return angle

func is_angle_in_range(angle, min_angle, max_angle):
	angle = normalize_angle(angle)
	return angle >= min_angle and angle <= max_angle

func point_on_line_segment(point, line_start, line_end):
	var segment_length = line_start.distance_to(line_end)
	var dist_to_start = point.distance_to(line_start)
	var dist_to_end = point.distance_to(line_end)
	return abs(dist_to_start + dist_to_end - segment_length) < 0.1

func remove_duplicate_points(points_array):
	var i = 0
	while i < points_array.size():
		var j = i + 1
		while j < points_array.size():
			if points_array[i]["position"].distance_to(points_array[j]["position"]) < 0.1:
				points_array.remove_at(j)
			else:
				j += 1
		i += 1

func line_intersection(p1, p2, p3, p4):
	var den = (p1.x - p2.x) * (p3.y - p4.y) - (p1.y - p2.y) * (p3.x - p4.x)
	
	if abs(den) < 0.0001:
		return null
	
	var t = ((p1.x - p3.x) * (p3.y - p4.y) - (p1.y - p3.y) * (p3.x - p4.x)) / den
	var u = -((p1.x - p2.x) * (p1.y - p3.y) - (p1.y - p2.y) * (p1.x - p3.x)) / den
	
	if t >= 0 and t <= 1 and u >= 0 and u <= 1:
		return Vector2(p1.x + t * (p2.x - p1.x), p1.y + t * (p2.y - p1.y))
	
	return null



func load_json_config(file_path: String):
	if not FileAccess.file_exists(file_path):
		push_error("JSON file does not exist: " + file_path)
		return null
	var file = FileAccess.open(file_path, FileAccess.READ)
	if not file:
		push_error("Failed to open JSON file: " + file_path)
		return null
	var json_string = file.get_as_text()
	file.close()
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	if parse_result != OK:
		push_error("JSON Parse Error: " + json.get_error_message() + " at line " + str(json.get_error_line()))
		return null
	return json.data
enum betweenDirectionsCase {
	top,
	bottom,
	both_toaching,
	center,
	none
	}

func get_structures_between_directions(start, angle_ray_1, end, angle_ray_2, damage, inverted=false):
	var start_wave_position = start["position"]
	var end_wave_position = end["position"]
	var angle1 = angle_ray_1
	var angle2 = angle_ray_2
	
	var order = []
	
	# Calculate ray directions
	var ray1_dir = Vector2(cos(angle1), sin(angle1))
	var ray2_dir = Vector2(cos(angle2), sin(angle2))
	
	for structure in Structures:
		if structure.id == start.id:
			continue
		var struct_pos=structure.startPos
		var ypos=start_wave_position.y+ray1_dir.y*(struct_pos.x-start_wave_position.x)/ray1_dir.x
		var ypos2=end_wave_position.y+ray2_dir.y*(struct_pos.x-end_wave_position.x)/ray2_dir.x
		var topypos=struct_pos.y>ypos
		var topypos2=struct_pos.y>ypos2
		
		var struct_end_pos=structure.endPos
		var ypos_end=start_wave_position.y+ray1_dir.y*(struct_end_pos.x-start_wave_position.x)/ray1_dir.x
		var ypos2_end=end_wave_position.y+ray2_dir.y*(struct_end_pos.x-end_wave_position.x)/ray2_dir.x
		var topypos_end=struct_end_pos.y>ypos_end
		var topypos2_end=struct_end_pos.y>ypos2_end
		var crosses_ray1 = (struct_pos.y > ypos) != (struct_end_pos.y > ypos_end)
		var crosses_ray2 = (struct_pos.y > ypos2) != (struct_end_pos.y > ypos2_end)
		
		# Check if structure is between both rays (one side above both rays, other side below both rays)
		var between_rays = (topypos!=topypos2_end)
		var currentCase=betweenDirectionsCase.none
		if (crosses_ray1 and crosses_ray2):
			currentCase=betweenDirectionsCase.both_toaching
		elif crosses_ray1:
			currentCase=betweenDirectionsCase.top
		elif crosses_ray2:
			currentCase=betweenDirectionsCase.bottom
		elif between_rays:
			currentCase=betweenDirectionsCase.center
		match currentCase:
			betweenDirectionsCase.both_toaching:
				var position_struct=Vector2(struct_pos.x,ypos)
				var start_position=start_wave_position
				var angle=angle_ray_1
				var angle_degrees=rad_to_deg(angle)
				var distance=start_position.distance_to(position_struct)+start.distance
				var dictOrder = {
					"start_position": start_position,
					"position": position_struct,
					"angle": angle,
					"angle_degrees": angle_degrees,
					"distance": distance,
					"powerName": structure.get("powerName", "unknown"),
					"currentPos": "startPos",
					"id": structure["id"],
					"damage": damage
				}
				order.append(dictOrder)
				var position_struct2=Vector2(struct_end_pos.x,ypos2_end)
				var start_position2=end_wave_position
				var angle_2=angle_ray_2
				var angle_degrees2=rad_to_deg(angle_2)
				var distance2=start_position2.distance_to(position_struct2)+end.distance
				var dictOrder2 = {
					"start_position": start_position2,
					"position": position_struct2,
					"angle": angle_2,
					"angle_degrees": angle_degrees2,
					"distance": distance2,
					"powerName": structure.get("powerName", "unknown"),
					"currentPos": "endPos",
					"id": structure["id"],
					"damage": damage
				}
				order.append(dictOrder2)
			betweenDirectionsCase.top:
				var position_struct=Vector2(struct_pos.x,ypos)
				var start_position=start_wave_position
				var angle=angle_ray_1
				var angle_degrees=rad_to_deg(angle)
				var distance=start_position.distance_to(position_struct)+start.distance
				var dictOrder = {
					"start_position": start_position,
					"position": position_struct,
					"angle": angle,
					"angle_degrees": angle_degrees,
					"distance": distance,
					"powerName": structure.get("powerName", "unknown"),
					"currentPos": "startPos",
					"id": structure["id"],
					"damage": damage
				}
				order.append(dictOrder)
				var position_struct2=struct_end_pos
				var alphaFactor=(struct_end_pos.y-ypos2_end)/(ypos-ypos2_end)
				var start_position2=end_wave_position+alphaFactor*(start_wave_position-end_wave_position)
				var angle_2=angle_ray_1+alphaFactor*(angle_ray_2-angle_ray_1)
				var angle_degrees2=rad_to_deg(angle_2)
				var distance2=start_position2.distance_to(position_struct2)+end.distance
				var dictOrder2 = {
					"start_position": start_position2,
					"position": position_struct2,
					"angle": angle_2,
					"angle_degrees": angle_degrees2,
					"distance": distance2,
					"powerName": structure.get("powerName", "unknown"),
					"currentPos": "endPos",
					"id": structure["id"],
					"damage": damage
				}
				order.append(dictOrder2)
			betweenDirectionsCase.bottom:
				var position_struct=struct_pos
				var alphaFactor=(struct_pos.y-ypos2_end)/(ypos-ypos2_end)
				var start_position=end_wave_position+alphaFactor*(start_wave_position-end_wave_position)
				var angle=angle_ray_2+alphaFactor*(angle_ray_1-angle_ray_2)
				var angle_degrees=rad_to_deg(angle)
				var distance=start_position.distance_to(position_struct)+start.distance
				var dictOrder = {
					"start_position": start_position,
					"position": position_struct,
					"angle": angle,
					"angle_degrees": angle_degrees,
					"distance": distance,
					"powerName": structure.get("powerName", "unknown"),
					"currentPos": "startPos",
					"id": structure["id"],
					"damage": damage
				}
				order.append(dictOrder)
				var position_struct2=Vector2(struct_end_pos.x,ypos2_end)
				var start_position2=end_wave_position
				var angle_2=angle_ray_2
				var angle_degrees2=rad_to_deg(angle_2)
				var distance2=start_position2.distance_to(position_struct2)+end.distance
				var dictOrder2 = {
					"start_position": start_position2,
					"position": position_struct2,
					"angle": angle_2,
					"angle_degrees": angle_degrees2,
					"distance": distance2,
					"powerName": structure.get("powerName", "unknown"),
					"currentPos": "endPos",
					"id": structure["id"],
					"damage": damage
				}
				order.append(dictOrder2)
			betweenDirectionsCase.center:
				var position_struct=struct_pos
				var alphaFactor=(struct_pos.y-ypos2_end)/(ypos-ypos2_end)
				var start_position=end_wave_position+alphaFactor*(start_wave_position-end_wave_position)
				var angle=angle_ray_2+alphaFactor*(angle_ray_1-angle_ray_2)
				var angle_degrees=rad_to_deg(angle)
				var distance=start_position.distance_to(position_struct)+start.distance
				var dictOrder = {
					"start_position": start_position,
					"position": position_struct,
					"angle": angle,
					"angle_degrees": angle_degrees,
					"distance": distance,
					"powerName": structure.get("powerName", "unknown"),
					"currentPos": "startPos",
					"id": structure["id"],
					"damage": damage
				}
				order.append(dictOrder)
				var position_struct2=struct_end_pos
				var alphaFactor2=(struct_end_pos.y-ypos2_end)/(ypos-ypos2_end)
				var start_position2=end_wave_position+alphaFactor2*(start_wave_position-end_wave_position)
				var angle_2=angle_ray_1+alphaFactor*(angle_ray_2-angle_ray_1)
				var angle_degrees2=rad_to_deg(angle_2)
				var distance2=start_position2.distance_to(position_struct2)+end.distance
				var dictOrder2 = {
					"start_position": start_position2,
					"position": position_struct2,
					"angle": angle_2,
					"angle_degrees": angle_degrees2,
					"distance": distance2,
					"powerName": structure.get("powerName", "unknown"),
					"currentPos": "endPos",
					"id": structure["id"],
					"damage": damage
				}
				order.append(dictOrder2)
			betweenDirectionsCase.none:
				continue
	
	if inverted:
		order.sort_custom(sort_by_ray_origin_inverted)
	else:
		order.sort_custom(sort_by_ray_origin)
	return order

func sort_by_ray_origin(a, b):
	if a.start_position.x != b.start_position.x:
		return a.start_position.x < b.start_position.x
	else:
		return a.distance < b.distance

func sort_by_ray_origin_inverted(a, b):
	if a.start_position.x != b.start_position.x:
		return a.start_position.x > b.start_position.x
	else:
		return a.distance < b.distance


# More robust intersection function


func instersection_pos_dir_pos_dir(pos1, dir1, pos2, dir2):
	# Standard line intersection formula for:
	# Line1: pos1 + t * dir1
	# Line2: pos2 + u * dir2
	
	var cross = dir1.x * dir2.y - dir1.y * dir2.x
	
	# Check if lines are parallel
	if abs(cross) < 0.0001:
		return null
	
	var diff = pos2 - pos1
	var t = (diff.x * dir2.y - diff.y * dir2.x) / cross
	
	return pos1 + t * dir1

func save_json_config(object, path):
	var user_dir = OS.get_user_data_dir()
	var file_path = user_dir + path+ "/buffs.json"
	# Create a FileAccess object for writing
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	if file:
		# Convert your data to JSON string
		var json_string = JSON.stringify(object)
		# Write the JSON string to file
		file.store_string(json_string)
		file.close()
	else:
		print("Error: Could not save file to path")
	return


func _on_button_pressed() -> void:
	attack(1)
