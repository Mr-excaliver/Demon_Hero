extends Area2D
signal shooting
@export var gun_knockback = 100
@onready var mainbody = $"."
@onready var holder = $Marker2D

var direction = Vector2.RIGHT.rotated(rotation)
const BULLET = preload("res://scenes/bullet.tscn")
@onready var bullet_firerate = $Firerate
@onready var reload = $reload
var can_fire = true
var magazine = PlayerStat.mag_size
var is_reloading = false
var current_mag = magazine


func _ready():
	PlayerStat.mag_change.connect(mag_size_update)
func _physics_process(_delta: float) -> void:

	var gun_rotation = mainbody.global_position.direction_to(get_global_mouse_position()).angle()
	mainbody.rotation = gun_rotation
	if Input.is_action_just_pressed("reload")&& current_mag < magazine && is_reloading == false:
		is_reloading = true
		current_mag = magazine
		reload.start()
	if Input.is_action_pressed("attack"):
		gun_knockback = 10
		shoot()


func shoot():
	
	if BULLET:
		var bullet = BULLET.instantiate()
		if current_mag == 0:
			can_fire = false
		if can_fire == true && is_reloading == false:
			emit_signal("shooting", gun_knockback)
			get_tree().current_scene.add_child(bullet)
			current_mag-= 1
			WaveManager.shake_initiate(1 , 1 , 1)
			PlayerStat.fired(current_mag)
			bullet_firerate.start()
			can_fire = false
			bullet.global_position = holder.global_position
			var bullet_rotation = holder.global_position.direction_to((get_global_mouse_position() + Vector2(randf_range(-10, 10), randf_range(-10, 10)))).angle()
			bullet.rotation = bullet_rotation



func _on_reload_timeout():
	is_reloading = false
	PlayerStat.fired(current_mag)


func _on_firerate_timeout():
	can_fire = true

func mag_size_update(mag):
	magazine = mag
