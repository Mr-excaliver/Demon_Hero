extends CharacterBody2D

@export var speed= 150

@onready var hitbox = $e_hitbox/CollisionShape2D
@onready var atk_cooldown = $attack

var player
var monument
var health = 10
var state = CHASE
var is_attacking = false

enum{
	CHASE,
	ATTACK,
	IDLE
}





func _ready():
	add_to_group("enemies")
	player = get_tree().get_first_node_in_group("player")
	monument = get_tree().get_first_node_in_group("monument")


func _physics_process(delta):

	if health<=0:

		queue_free()
	match state:
		CHASE:
			chase()
		ATTACK:
			attack()
		IDLE:
			idle()
	
	move_and_slide()



func chase():
	if not monument:
		state = IDLE
		return
	if not player:
		velocity = speed * (monument.global_position - self.global_position).normalized()
	else:
		var dist_player = (player.global_position - self.global_position).length()
		var dist_monu = (monument.global_position - self.global_position).length()
		if(dist_player <dist_monu):
			velocity = speed * (player.global_position - self.global_position).normalized()
		else:
			velocity = speed * (monument.global_position - self.global_position).normalized()
	

func idle():
	velocity = Vector2.ZERO

func attack():
	velocity = Vector2.ZERO
	if not is_attacking:
		is_attacking = true
		hitbox.disabled = false
		atk_cooldown.start()




func _on_detector_area_entered(area):
	state = ATTACK



func _on_attack_timeout():
	hitbox.disabled = true
	is_attacking = false


func _on_detector_area_exited(area):
	if area.name == "mhurtbox":
		state = IDLE
	state = CHASE


func _on_hurtbox_area_entered(area):
	if area.has_method("destroy"):
		area.destroy()
		health -=2
