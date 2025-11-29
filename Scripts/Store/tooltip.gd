extends Control

func show_tooltip(name_power, description,mouse_position):
	$VBoxContainer/name.text=name_power
	$VBoxContainer/description.text=description
	self.visible=true
	self.size.y=$VBoxContainer.size.y
	# Wait for next frame to ensure proper sizing
	call_deferred("update_position", mouse_position)

func update_position(mouse_position):
	# Get screen/viewport size
	var viewport_rect = get_viewport().get_visible_rect()
	var screen_size = viewport_rect.size
	var screen_position = viewport_rect.position  # Usually (0, 0) but could be different
	
	# Get tooltip size
	var tooltip_size = self.size
	
	# Configuration
	var tooltip_offset = Vector2(0, 20)  # Offset from mouse
	var screen_margin = 10                # Margin from screen edges
	# Calculate desired position (offset from mouse)
	var desired_position = mouse_position - Vector2(tooltip_size.x/2.0,0)  + tooltip_offset
	var final_position = desired_position
	# Check right edge
	if desired_position.x + tooltip_size.x > screen_size.x - screen_margin:
		final_position.x = screen_size.x - tooltip_size.x - screen_margin
	
	# Check bottom edge  
	if desired_position.y + tooltip_size.y > screen_size.y - screen_margin:
		final_position.y = mouse_position.y-tooltip_offset.y - tooltip_size.y
	
	# Check left edge
	if final_position.x < screen_margin:
		final_position.x = screen_margin
	
	# Check top edge
	if final_position.y < screen_margin:
		final_position.y = screen_margin
	
	self.global_position = final_position

func hide_tooltip():
	self.visible=false
