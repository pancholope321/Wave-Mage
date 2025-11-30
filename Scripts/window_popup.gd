extends Control


func _on_close_window_pressed() -> void:
	self.visible=false


func _on_asset_used_button_pressed() -> void:
	self.visible=true
