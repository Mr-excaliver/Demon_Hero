extends Node

signal health_change
signal speed_change
signal mag_change
signal monu_change

var health = 10
var speed = 500
var mag_size = 10
var damage = 10
var monument_health = 50
var died_count = 0

func apply_buff(buff , value):
	match buff:
		"health":
			health += value
			emit_signal("health_change", health)
		"mag_size":
			mag_size += value
			emit_signal("mag_change", mag_size)
		"damage":
			damage += value
		"speed":
			speed += value
			emit_signal("speed_change", speed)
		"monument_health":
			monument_health += value
			emit_signal("monu_change", monument_health)


func reset():
	health = 10
	speed = 500
	mag_size = 10
	damage = 10
	monument_health = 50
	died_count = 0
