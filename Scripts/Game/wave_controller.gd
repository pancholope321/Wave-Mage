extends Node2D

@export var wave_start:Node2D
@export var wave_end1:Node2D
@export var wave_end2:Node2D
@export var wall_point_1:Node2D
@export var wall_point_2:Node2D
@export var wall_point_3:Node2D
@export var wall_point_4:Node2D
@export var wall_point_5:Node2D
@export var wall_point_6:Node2D
var script_instances = {}

var Structures = []
var power_file_relation
func _ready() -> void:
	power_file_relation = await load_json_config("res://ConfigFiles/power_file_relation.json")
	attack(1)

# when attack is pressed the wave is propagating
func attack(damage,start_position=wave_start.position):
	# this are the structures that are placed on the canvas (example)
	# the powerName is the actual function name, so wall calls func wall
	var listOfPowers=[{"id":1,"powerName": "duplicatePower",
		"startPos": wall_point_1.global_position, 
		"endPos": wall_point_2.global_position},
		{"id":2,"powerName": "wall",
		"startPos": wall_point_3.global_position, 
		"endPos": wall_point_4.global_position},
		{"id":3,"powerName": "wall",
		"startPos": wall_point_5.global_position, 
		"endPos": wall_point_6.global_position}]
	var dict = {"id":0,
		"powerName": "enemy",
		"startPos": wave_end1.global_position, 
		"endPos": wave_end2.global_position
	}
	
	Structures.append(dict)
	for i in range(listOfPowers.size()):
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
	return currentLines

var linesDrawn=[]
func _draw():
	var size=20.0
	for line in linesDrawn:
		var start_position =line.start_position
		var end_position = line.position
		var random_color = Color(randf(), randf(), randf())
		
		draw_line(start_position, end_position, random_color, size)
		size*=0.75


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
		
		totalDamage += script_instances[filepath].call(functionName, self, firstBeam[i*2], firstBeam[i*2+1])
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
