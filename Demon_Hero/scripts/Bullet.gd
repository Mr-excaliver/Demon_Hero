extends Area2D

@export var speed = 1000



func _physics_process(delta):
	var direction = Vector2.RIGHT.rotated(rotation)
	global_position += speed * direction * delta 
	



func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func destroy():
	queue_free()
