extends Node2D

@export var wave_start:Node2D
@export var wave_end1:Node2D
@export var wave_end2:Node2D
@export var wall_point_1:Node2D
@export var wall_point_2:Node2D
@export var wall_point_3:Node2D
@export var wall_point_4:Node2D



var Structures = []
func _ready() -> void:
	attack()

func attack():
	var listOfPowers=[{"powerName": "wall",
		"startPos": wall_point_1.global_position, 
		"endPos": wall_point_2.global_position},
		{"powerName": "wall2",
		"startPos": wall_point_3.global_position, 
		"endPos": wall_point_4.global_position}]
	var dict = {
		"powerName": "enemy",
		"startPos": wave_end1.global_position, 
		"endPos": wave_end2.global_position
	}
	
	Structures.append(dict)
	for i in range(listOfPowers.size()):
		#var dictPower = listOfPowers[i].get_dictionary()
		#Structures.append(dictPower)
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
				"currentPos":pos
			}
			order.append(dictOrder)
	
	order.sort_custom(sort_by_angle_then_distance)
	print(order)
	paint_ordered_walls(order)
	

func paint_ordered_walls(order):
	var currentStructures=[]
	var activePower={"distance"=99999999}
	for element in order:
		if element["currentPos"]=="startPos":
			currentStructures.append(element)
			if element.distance<activePower.distance:
				if activePower.has("position"):
					var newElements=order.filter(func(x): return x.powerName == activePower.powerName)
					var nepos1=newElements[0].position
					var nepos2=newElements[1].position
					var neposang1=newElements[0].angle
					var neposang2=newElements[1].angle
					var newElementPosition=nepos2+(nepos1-nepos2)*(neposang2-element["angle"])/(neposang2-neposang1)
					linesDrawn.append(newElementPosition)
				activePower=element
				linesDrawn.append(element["position"])
			else:
				continue
		elif element["currentPos"]=="endPos":
			currentStructures = currentStructures.filter(func(x): return x.powerName != element.powerName)
			if activePower.powerName==element.powerName:
				linesDrawn.append(element["position"])
				if currentStructures.size()>0:
					currentStructures.sort_custom(sort_by_angle_then_distance)
					print("currentStructures ",currentStructures)
					activePower=currentStructures[0]
					var newElements=order.filter(func(x): return x.powerName == activePower.powerName)
					var nepos1=newElements[0].position
					var nepos2=newElements[1].position
					var neposang1=newElements[0].angle
					var neposang2=newElements[1].angle
					var newElementPosition=nepos2+(nepos1-nepos2)*(neposang2-element["angle"])/(neposang2-neposang1)
					linesDrawn.append(newElementPosition)
				else:
					activePower={"distance"=99999999}
	print("linesDrawn ",linesDrawn)


var linesDrawn=[]
func _draw():
	print("drawing")
	var start_position = wave_start.global_position
	var size=20.0
	for line in linesDrawn:
		var end_position = line
		var random_color = Color(randf(), randf(), randf())
		
		draw_line(start_position, end_position, random_color, size)
		size*=0.75


func sort_by_angle_then_distance(a, b):
	if a.angle != b.angle:
		return a.angle < b.angle
	else:
		return a.distance < b.distance
