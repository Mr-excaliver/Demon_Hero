extends CharacterBody2D


var health = 50
var gaurds = 0
const enemy = preload("res://scenes/night_enemy.tscn")
@onready var collection = $spawnpoints
var spawn_points = []
@onready var hurtbox = $mhurtbox/CollisionShape2D2
@onready var invinc = $invinc
@onready var cooldwon = $cooldown

func _ready():
	add_to_group("monument")
	for i in collection.get_children():
		if i is Marker2D:
			spawn_points.append(i)
	


func _process(_delta):
	if health ==0:
		queue_free()
	
	if gaurds ==0:
		spawn()
	
	


func spawn():
	for i in spawn_points:
		var enem = enemy.instantiate()
		enem.global_position = i.global_position
		get_tree().current_scene.add_child(enem)
		gaurds +=1
		enem.died.connect(_on_spawned_died.bind())


func _on_hurtbox_area_entered(area):
	if area.has_method("destroy"):
		health -=10
		area.destroy()


func _on_spawned_died():
	gaurds -=1

