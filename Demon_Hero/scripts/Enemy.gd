extends CharacterBody2D

signal enemy_died
var speed= EnemyStat.enemy_speed

@onready var hitbox = $e_hitbox/CollisionShape2D
@onready var atk_cooldown = $attack

var base_score = 10
var player
var monument
var health = EnemyStat.enemy_health
var state = State.CHASE
var is_attacking = false

enum State{
	CHASE,
	ATTACK,
	IDLE
}


func _ready():
	add_to_group("enemies")
	player = get_tree().get_first_node_in_group("player")
	monument = get_tree().get_first_node_in_group("monument")
	self.enemy_died.connect(WaveManager.day_enemy_died)


func _physics_process(delta):

	if health<=0:
		emit_signal("enemy_died")
		ScoreManager.score += base_score * WaveManager.wave
		ScoreManager.score_updated()
		queue_free()
	match state:
		State.CHASE:
			chase()
		State.ATTACK:
			attack()
		State.IDLE:
			idle()
	
	move_and_slide()



func chase():
	if not monument:
		state = State.IDLE
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
	state = State.ATTACK



func _on_attack_timeout():
	hitbox.disabled = true
	is_attacking = false


func _on_detector_area_exited(area):
	if area.name == "mhurtbox":
		state = State.IDLE
	state = State.CHASE


func _on_hurtbox_area_entered(area):
	if area.has_method("destroy"):
		area.destroy()
		health -=PlayerStat.damage
