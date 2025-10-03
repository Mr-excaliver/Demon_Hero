extends Node

var base_health = 10
var base_speed = 200
var base_damage = 2
var base_spawner = 50

var enemy_health = base_health
var enemy_speed = base_speed
var enemy_damage = base_damage
var spawner_health = base_spawner




func update_stats():
	enemy_health += base_health * WaveManager.wave
	enemy_damage += base_damage * WaveManager.wave
	spawner_health += base_damage * WaveManager.wave


func reset():
	enemy_health = base_health
	enemy_damage = base_damage
	spawner_health = base_spawner
