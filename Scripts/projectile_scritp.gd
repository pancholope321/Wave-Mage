extends Sprite2D
var start=Vector2(0,0)
var end=Vector2(0,0)
var h=0
var k=0
var a=0
@export var rotate_offset_deg=0
func setup_start_end(start_set,end_set):
	start=start_set
	end=end_set
	var y1=start.y
	var y2=end.y
	var x1=start.x
	var x2=end.x
	k=min(y1,y2)-50.0
	if abs(y1-y2)>10:
		h=(sqrt((y1 - k)*(y2 - k)*(x1 - x2)**2) + k*x1 - k*x2 - x1*y2 + x2*y1)/(y1 - y2)
	else:
		h=(x1+x2)/2.0
	a=(y1-k)/((x1-h)**2)
	self.global_position=start
	self.visible=true
	pass


func launch_projectile(regulator):
	var x1=start.x
	var x2=end.x
	var x=x1+regulator*(x2-x1)
	var y=a*((x-h)**2)+k
	var xderiv=x
	var yderiv=a*((x-h))
	var direction=atan(yderiv)
	self.global_position=Vector2(x,y)
	self.rotation=direction + PI*rotate_offset_deg/180.0

func end_action():
	#explotion and then queuefree, for example
	self.queue_free()
	pass
