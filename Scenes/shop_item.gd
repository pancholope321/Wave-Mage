extends Button

var itemName=null
@export var level : int 
@export var isUpgrade : bool
@export var labelPrice :Label
@export var texture: TextureRect
var price=3
# Called when the node enters the scene tree for the first time.
func set_item(nameItem):
	itemName=nameItem 
	level = Global.attrLvlDict["unlocked_powers"][itemName]
	var priceDict=Global.inforPowerDict["power_costs"][itemName]
	print("priceDict: ",priceDict)
	price=priceDict["price"]+level*priceDict["growth_per_level"]
	labelPrice.text = str(roundi(price))
	var image=Global.inforPowerDict["power_image"][itemName]
	var loaded_image=load(image)
	texture.texture=loaded_image

func updatePrice():
	Global.attrLvlDict["unlocked_powers"][itemName] += 1
	level = Global.attrLvlDict["unlocked_powers"][itemName] 
	var priceDict=Global.inforPowerDict["power_costs"][itemName]
	price=priceDict["price"]+level*priceDict["growth_per_level"]
	labelPrice.text = str(roundi(price))



func _on_pressed() -> void:
	updatePrice()

func get_price():
	return roundi(self.price)
