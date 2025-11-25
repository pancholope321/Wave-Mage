extends Node2D

@onready var buyBtn = $Buy 
@export var itemName : String
@export var level : int 
@export var isUpgrade : bool
var price=3
# Called when the node enters the scene tree for the first time.
func _ready() -> void: 
	level = Global.attrLvlDict[itemName]
	var priceDict=Global.inforPowerDict["power_costs"][itemName]
	print("priceDict: ",priceDict)
	price=priceDict["price"]+level*priceDict["growth_per_level"]
	buyBtn.text = str(price)

func updatePrice():
	Global.attrLvlDict[itemName] += 1
	level = Global.attrLvlDict[itemName] 
	var priceDict=Global.inforPowerDict[itemName]
	price=priceDict["price"]+level*priceDict["growth_per_level"]
	buyBtn.text = str(price)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
