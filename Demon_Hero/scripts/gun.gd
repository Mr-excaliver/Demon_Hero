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
@export var magazine = 30
var is_reloading = false
var current_mag = magazine


# warning-ignore:unused_argument
func _physics_process(delta: float) -> void:
	#mainbody.global_position = get_parent().get_node("gun_position").global_position
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
			#get_parent().get_parent().get_node("ScreenShake").screen_shake(0.5,4,100)
			get_tree().current_scene.add_child(bullet)
			current_mag-= 1
			bullet_firerate.start()
			can_fire = false
			bullet.global_position = holder.global_position
			var bullet_rotation = holder.global_position.direction_to((get_global_mouse_position() + Vector2(randf_range(-10, 10), randf_range(-10, 10)))).angle()
			bullet.rotation = bullet_rotation



func _on_reload_timeout():
	is_reloading = false


func _on_firerate_timeout():
	can_fire = true
