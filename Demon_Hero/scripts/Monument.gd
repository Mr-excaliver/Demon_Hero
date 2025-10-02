extends CharacterBody2D

var health = 50
@onready var hurtbox = $mhurtbox/CollisionShape2D2
@onready var invinc = $invinc

func _ready():
	add_to_group("monument")


func _process(_delta):
	if health ==0:
		queue_free()




func _on_hurtbox_area_entered(area):
	if area.name == "e_hitbox":
		health -=10
		hurtbox.disabled = true
		invinc.start()
	
	


func _on_invinc_timeout():
	hurtbox.disabled = false
