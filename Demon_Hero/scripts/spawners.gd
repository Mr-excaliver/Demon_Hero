extends CharacterBody2D

var base_score = 70
var health = EnemyStat.spawner_health
var gaurds = 4
const enemy = preload("res://scenes/night_enemy.tscn")
@onready var collection = $spawnpoints
var spawn_points = []
@onready var cooldown = $cooldown

var buff_list = ["health", "speed", "mag_size" , "damage", "monument_health"]

func _ready():
	add_to_group("Spawners")
	for i in collection.get_children():
		if i is Marker2D:
			spawn_points.append(i)
	


func _process(_delta):
	if health <=0:
		ScoreManager.score += base_score * WaveManager.wave
		buff()
		queue_free()
	
	if gaurds ==0:
		cooldown.start()
	
	


func spawn():
	for i in spawn_points:
		var enem = enemy.instantiate()
		enem.global_position = i.global_position
		get_tree().current_scene.add_child(enem)
		gaurds +=1
		enem.died.connect(_on_spawned_died.bind())


func _on_hurtbox_area_entered(area):
	if area.has_method("destroy"):
		health -=PlayerStat.damage
		area.destroy()


func _on_spawned_died():
	gaurds -=1

func buff():
	var new_buff = buff_list[randi()%buff_list.size()]
	var value = randi()%(10) * WaveManager.wave
	PlayerStat.apply_buff(new_buff , value)



func _on_cooldown_timeout():
	spawn()
