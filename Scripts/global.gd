extends Node
# we need to add functions to have data permanence, 
# lets use the json on the config files
# ConfigFiles>player_statistics>json
var totalCoins = 0 
var upgradePriceDict = {
	"Health" : [100, 200, 300, 400]
} 
var attrLvlDict = {
	"Health" : 0
}
var healthUpgradePrices = [100, 200, 300, 400]

var coinsWon=0
