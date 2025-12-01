extends Node2D 

@onready var settings = $"Settings Popup" 
@onready var startBtn = $"Camera2D/Start Button" 
@onready var continueBtn = $"Camera2D/continue Button"
@export var parallax_bg:ParallaxBackground
var viewport_size=Vector2(1200,900)
func _ready() -> void:
	var viewport_rect = get_viewport().get_visible_rect()
	viewport_size = viewport_rect.size
	print("viewport_size: ",viewport_size)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var mouse=get_global_mouse_position()
	var position_parallax=mouse-viewport_size*0.5
	parallax_bg.scroll_base_offset=position_parallax
	pass

func start_game(): 
	Sfx.play("PositiveButtonPress", true)
	Global.load_new_game()
	get_tree().change_scene_to_file("res://Scenes/fightScene.tscn") 

func continue_game():
	Sfx.play("PositiveButtonPress", true) 
	get_tree().change_scene_to_file("res://Scenes/shopScene.tscn") 

func display_settings(): 
	#settings.get_tree().paused = false
	Sfx.play("NeutralButtonPress", true)
	settings.visible = true 
	startBtn.visible = false 
	continueBtn.visible = false


	
