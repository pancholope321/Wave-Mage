extends Node

# nothing function
func wall_vine(container,start,end,context):
	print("wall")
	print("start: ",start)
	print("end: ",end)
	container.setup_eliminate_end_turn(start.node)
	return 0
