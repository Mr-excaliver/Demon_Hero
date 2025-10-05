extends CharacterBody2D

var base_score = 70
var health = EnemyStat.spawner_health
var can_spawn = true
const enemy = preload("res://scenes/night_enemy.tscn")
@onready var collection = $spawnpoints
var spawn_point = []


var buff_list = ["health", "speed", "mag_size" , "damage", "monument_health"]

func _ready():
	add_to_group("Spawners")
	for i in collection.get_children():
		if i is Marker2D:
			spawn_point.append(i)



func _process(_delta):
	if health <=0 && $Label.visible == false:
		ScoreManager.score += base_score * WaveManager.wave
		ScoreManager.score_updated()
		buff()
		$Sprite2D.visible = false
		$Label.visible = true
		await get_tree().create_timer(1).timeout
		queue_free()
	if can_spawn:
		spawn()


func spawn():
	can_spawn = false
	for i in spawn_point:
		var enem = enemy.instantiate()
		enem.global_position = i.global_position
		get_tree().current_scene.add_child(enem)



func _on_hurtbox_area_entered(area):
	if area.has_method("destroy"):
		health -=PlayerStat.damage
		WaveManager.shake_initiate(1 , 3 , 3)
		area.destroy()




func buff():
	var new_buff = buff_list[randi()%buff_list.size()]
	var value = 2 + randi()%(10) * WaveManager.wave
	$Label.text = "+" + str(value) + " " + new_buff
	PlayerStat.apply_buff(new_buff , value)



