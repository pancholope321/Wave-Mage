extends Node2D 

@onready var coinDisplay = $Camera2D/Coins 


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	coinDisplay.text = str(int(Global.totalCoins))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spend(cost):
	Global.totalCoins -= cost 
	coinDisplay.text = Global.totalCoins
