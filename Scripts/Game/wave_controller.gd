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
func attack(damage):
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
		
		totalDamage += script_instances[filepath].call(functionName, firstBeam[i*2], firstBeam[i*2+1])
	print("totalDamage: ",totalDamage)
# with this function we visualize the borders of the waves
func paint_ordered_walls(order):
	var currentStructures=[]
	var activePower={"distance"=99999999}
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
					linesDrawn.append(newdict)
				activePower=element
				linesDrawn.append(element)
			else:
				continue
		elif element["currentPos"]=="endPos":
			currentStructures = currentStructures.filter(func(x): return x.id != element.id)
			if activePower.powerName==element.powerName:
				linesDrawn.append(element)
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
				else:
					activePower={"distance"=99999999}
	return linesDrawn
	
		


var linesDrawn=[]
func _draw():
	var start_position = wave_start.global_position
	var size=20.0
	for line in linesDrawn:
		var end_position = line.position
		var random_color = Color(randf(), randf(), randf())
		
		draw_line(start_position, end_position, random_color, size)
		size*=0.75


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
