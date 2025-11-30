extends Sprite2D

var start=Vector2(0,0)
var end=Vector2(0,0)
@export var starting_position:Vector2
@export var animation_player:AnimationPlayer

func setup_start_end(start_set,end_set,wave_controller):
	start=start_set
	end=end_set
	var texture_size=texture.get_size()
	self.global_position=end + starting_position

	self.visible=true

func launch_projectile(regulator):
	if animation_player.has_animation("Attack"):
		var anim = animation_player.get_animation("Attack")
		animation_player.play("Attack")
		animation_player.seek(regulator * anim.length)  # Convert 0-1 to actual time
		
func end_action(wave_controller):
	self.queue_free()
	pass
