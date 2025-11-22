extends Node2D

@onready var coinTotalLabel = $"Camera2D/Coin Total" 
@onready var coinsWonLabel = $"Camera2D/Coins Won"
var coinsWon : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	coinsWon = load_coins()
	Global.totalCoins += coinsWon


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func load_coins():
	pass
