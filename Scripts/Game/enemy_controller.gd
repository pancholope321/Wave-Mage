extends Node2D

@export var player_node=Area2D
@export var wave_controller=Node2D
func setupPlayerNode(player_node_set):
	player_node=player_node_set
func start_attack(enemyList):
	for enemy in enemyList:
		await enemy.animate_enemy_attack(player_node)
	wave_controller.end_enemy_turn()
