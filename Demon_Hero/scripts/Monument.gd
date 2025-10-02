extends CharacterBody2D

var health = PlayerStat.monument_health
@onready var hurtbox = $mhurtbox/CollisionShape2D2
@onready var invinc = $invinc

func _ready():
	add_to_group("monument")
	PlayerStat.monu_change.connect(health_change)


func _process(_delta):
	if health ==0:
		queue_free()




func _on_hurtbox_area_entered(area):
	if area.name == "e_hitbox":
		health -=EnemyStat.enemy_damage
		hurtbox.disabled = true
		invinc.start()
	
	


func _on_invinc_timeout():
	hurtbox.disabled = false


func health_change(new_health):
	health = new_health
