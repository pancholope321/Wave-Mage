extends Node2D

@onready var buyBtn = $Buy 
@export var itemName : String
@export var level : int 
@export var isUpgrade : bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void: 
	level = Global.attrLvlDict[itemName]
	buyBtn.text = str(Global.upgradePriceDict[itemName][level])

func updatePrice():
	Global.attrLvlDict[itemName] += 1
	level = Global.attrLvlDict[itemName] 
	buyBtn.text = Global.upgradePriceDict[itemName][level]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
