extends Node

var wave = 1
var phase = DAY
var respawn_delay =  5

const monument = preload("res://scenes/monument.tscn")
const player = preload("res://scenes/player.tscn")
const enemy = preload("res://scenes/enemy.tscn")
const spawners = preload("res://scripts/spawners.gd")


enum {
	DAY,
	NIGHT
}


func day():
	
	pass
	
func night():
	pass
	

func game_over():
	get_tree().paused = true
	get_tree().change_scene_to_file("")
	get_tree().paused = false
	PlayerStat.reset()
	EnemyStat.reset()
	wave = 1
	
	
	
func player_died():
	if phase ==DAY:
		await get_tree().create_timer(respawn_delay * PlayerStat.died_count).timeout
		spawn()
	else:
		game_over()


func spawn():
	var play = player.instantiate()
	var monument = get_tree().get_first_node_in_group("monument")
	play.global_position.x = monument.global_position.x
	play.global_position.y = monument.global_position.y + 500
	get_tree().current_scene.add_child(play)
	
