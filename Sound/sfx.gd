extends Node

var list=[]
var nameList=[]
# Called when the node enters the scene tree for the first time.
func clear():
	var children=get_children()
	for child in children:
		child.stop()

func initial_volume():
	var children=get_children()
	list=[]
	nameList=[]
	for child in children:
		list.append(child.volume_db)
		nameList.append(child.name)

func change_volume(volumeMaster,volumeMusic,volumeSFX):
	var vSFX=volumeMaster*volumeSFX
	var vMusic=volumeMaster*volumeMusic
	if list==[]:
		initial_volume()
	
	var musicNodes=get_tree().get_nodes_in_group("musicSFX")
	for nodeS in musicNodes:
		var index=nameList.find(nodeS.name)
		nodeS.volume_db=list[index]-(36.0*(1.0-vMusic))
	var sfxnodes=get_tree().get_nodes_in_group("SFXSFX")
	for nodeS in sfxnodes:
		var index=nameList.find(nodeS.name)
		nodeS.volume_db=list[index]-(36.0*(1-vSFX))
	
func clear_music():
	var children=get_children()
	for child in children:
		if child.is_in_group("musicSFX"):
			child.stop()

func clear_sfx():
	var children=get_children()
	for child in children:
		if child.is_in_group("SFXSFX"):
			child.stop()

func play(nameObject,one=false):
	var nodePlayed=get_node(nameObject)
	if !one:
		nodePlayed.stop()
	nodePlayed.play()
