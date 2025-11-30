extends Sprite2D

var start=Vector2(0,0)
var end=Vector2(0,0)
@export var starting_position:Vector2
@export var animation_player:AnimationPlayer
@export var structure:PackedScene
@export var key:String
var wave_controller:Node2D
var final_position=Vector2(0,0)
func setup_start_end(start_set,end_set,wave_controller_set):
	start=start_set
	end=end_set
	var texture_size=texture.get_size()
	wave_controller=wave_controller_set
	final_position=wave_controller.get_random_position()
	self.global_position=final_position
	self.visible=true

func launch_projectile(regulator):
	if animation_player.has_animation("Attack"):
		var anim = animation_player.get_animation("Attack")
		animation_player.play("Attack")
		animation_player.seek(regulator * anim.length)  # Convert 0-1 to actual time
		
func end_action(wave_controller):
	var instance=structure.instantiate()
	instance.set_position_off(final_position)
	wave_controller.add_structure(instance,key)
	self.queue_free()
	pass
