extends "res://general_scripts/PhysicsObject.gd"

#constants
const MOVEMENT_SPEED = 120
const JUMP_SPEED = 200
const H_ACCELERATION = .1

#enums
enum states {IDLE, MOVE, JUMP, FALL, SELF_DESTRUCT, EXPLODING}

#variables
var is_flipped = false

onready var sprite = $Sprite
onready var animation_player = $AnimationPlayer
onready var jump_sound = $JumpSound
onready var explosion_sound = $ExplosionSound

func _ready():
	pass

func _physics_process(delta):
	if state != SELF_DESTRUCT and state != EXPLODING:
		#horizontal movement
		var target_speed = 0
		if Input.is_action_pressed("ui_left"):
			target_speed -= 1
			is_flipped = true
		if Input.is_action_pressed("ui_right"):
			target_speed += 1
			is_flipped = false
		
		target_speed *= MOVEMENT_SPEED
		
		#jumping
		if(is_grounded and Input.is_action_just_pressed("ui_up")):
			linear_velocity.y = -JUMP_SPEED
			jump_sound.play(0)
		elif Input.is_action_just_released("ui_up"):
			if linear_velocity.y < 0:
				linear_velocity.y = linear_velocity.y * 0.5
		
		linear_velocity.x = lerp(linear_velocity.x, target_speed, H_ACCELERATION)
		
		if Input.is_action_just_pressed("ui_select"):
			change_state(SELF_DESTRUCT)
		
	else:
		linear_velocity.x = lerp(linear_velocity.x, 0, H_ACCELERATION)
	
	#change sprite direction
	if is_flipped:
		sprite.scale.x = -1
	else:
		sprite.scale.x = 1
	
	#animations
	if state == SELF_DESTRUCT or state == EXPLODING:
		pass
	elif(abs(linear_velocity.x) > H_ANIMATION_CHANGE and is_grounded):
		change_state(MOVE)
	elif linear_velocity.y > 0:
		change_state(FALL)
	elif(linear_velocity.y < 0 or !is_grounded):
		change_state(JUMP)
	else:
		change_state(IDLE)
	
	animation_player.current_animation = animation
	
func change_state(new_state):
	.change_state(new_state)
	match state:
		IDLE:
			animation = "idle"
		MOVE:
			animation = "move"
		JUMP:
			animation = "jump"
		FALL:
			animation = "fall"
		SELF_DESTRUCT:
			animation = "self_destruct"
		EXPLODING:
			animation = "exploding"
			explosion_sound.play(0)
	

func _on_AnimationPlayer_animation_finished(anim_name):
	match anim_name:
		"self_destruct":
			self.add_child(preload("res://actors/effects/explosion/Explosion.tscn").instance())
			change_state(EXPLODING)
		"exploding":
			if Input.is_action_pressed("ui_select"):
				self.add_child(preload("res://actors/effects/explosion/Explosion.tscn").instance())
				change_state(EXPLODING)
			else:
				change_state(IDLE)