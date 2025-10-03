extends Node

var wave = 1
var phase = Phase.IDLE
var respawn_delay =  5
var base_day_spawn = 7
var base_night_spawn = 5
var spawned = 0
var spawn_points = []
const monument = preload("res://scenes/monument.tscn")
const player = preload("res://scenes/player.tscn")
const enemy = preload("res://scenes/enemy.tscn")
const spawners = preload("res://scenes/spawners.tscn")

var monument_position = Vector2(1000, 1000)

enum Phase{
	IDLE,
	DAY,
	NIGHT,
	GAME_OVER
}


func day():
	if phase == Phase.DAY:
		var wait_time = 3
		spawn_points_gen(base_day_spawn * wave)
		var monument_existence = get_tree().get_first_node_in_group("monument")
		if not monument_existence:
			var monu = monument.instantiate()
			monu.global_position = monument_position
			get_tree().current_scene.add_child(monu)
		await get_tree().create_timer(1.5).timeout
		for i in spawn_points:
			var enem = enemy.instantiate()
			enem.global_position = i
			get_tree().current_scene.add_child(enem)
			spawned +=1
			await get_tree().create_timer(wait_time).timeout
			wait_time *= 0.9



	
func night():
	if phase == Phase.NIGHT:
		spawn_points_gen(base_night_spawn * wave)
		var monument_existence =  get_tree().get_first_node_in_group("monument")
		if monument_existence:
			monument_existence.remove()
		await get_tree().create_timer(1.5).timeout
		for i in spawn_points:
			var spawn = spawners.instantiate()
			spawn.global_position = i
			get_tree().current_scene.add_child(spawn)
		await get_tree().create_timer(1 * wave).timeout
		for node in get_tree().get_nodes_in_group("N_enemies"):
			node.queue_free()
		for node in get_tree().get_nodes_in_group("Spawners"):
			node.queue_free()
		
		phase = Phase.DAY
		wave+=1
		day()


func game_over():
	phase = Phase.GAME_OVER
	get_tree().paused = true
	get_tree().change_scene_to_file("res://ui_scenes/end_game.tscn")
	get_tree().paused = false
	PlayerStat.reset()
	EnemyStat.reset()
	wave = 1
	
	
	
func player_died():
	if phase ==Phase.DAY:
		await get_tree().create_timer(respawn_delay * PlayerStat.died_count).timeout
		spawn()
	else:
		game_over()

func day_enemy_died():
	spawned -= 1
	print("reduced")
	if spawned ==0:
		phase = Phase.NIGHT
		print("changed")
		night()

func spawn():
	var play = player.instantiate()
	var monu = get_tree().get_first_node_in_group("monument")
	play.global_position.x = monu.global_position.x
	play.global_position.y = monu.global_position.y - 250
	get_tree().current_scene.add_child(play)

func spawn_points_gen(base):
	spawn_points.clear()
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	for i in range(base):
		var radii = rng.randi_range(1000 , 1000 * wave)
		var angle = rng.randi_range(0 , 360)
		var x = radii * sin(deg_to_rad(angle))
		var y = radii * cos(deg_to_rad(angle))
		spawn_points.append(Vector2(x,y))
	
	
func start_game():
	await get_tree().create_timer(1.5).timeout
	day()
