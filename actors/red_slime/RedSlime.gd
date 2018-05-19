extends "res://general_scripts/PhysicsObject.gd"

#constants
const MOVEMENT_SPEED = 40
const CHASE_SPEED = 80
const JUMP_SPEED = 200
const H_ACCELERATION = .5

#enums
enum states {IDLE, MOVE, JUMP, FALL}

#variables
var is_flipped = false
var is_chasing = false

var random_counter = 0
var random_direction = rand_range(-1, 1)
var random_jump = rand_range(0, 10)

var chase_target = self

onready var sprite = $Sprite
onready var animation_player = $AnimationPlayer
onready var chase_area = $ChaseArea

func _ready():
	state = IDLE
	pass

func _physics_process(delta):
	#recalculate random movement
	if random_counter > 1:
		random_direction = rand_range(-1, 1)
		random_jump = rand_range(0, 10)
		random_counter = 0;
	
	#horizontal movement
	var target_speed = 0
	if !is_chasing:
		random_counter += delta
		
		if random_direction < -0.25:
			target_speed -= 1
			is_flipped = true
		elif random_direction > 0.25:
			target_speed += 1
			is_flipped = false
		
		target_speed *= MOVEMENT_SPEED
	
		#jumping
		if(is_grounded and random_jump > 8.5):
			linear_velocity.y = -JUMP_SPEED
			random_jump = rand_range(0, 10)
	
	#chase based on target position
	else:
		var chase_direction = (chase_target.position - position).normalized()
		
		if chase_direction.x < 0:
			target_speed -= 1
		if chase_direction.x > 0:
			target_speed += 1
		
		target_speed *= CHASE_SPEED
		
	linear_velocity.x = lerp(linear_velocity.x, target_speed, H_ACCELERATION)
	
	#change sprite direction
	if is_flipped:
		sprite.scale.x = -1
	else:
		sprite.scale.x = 1
	
	#animations
	if state == null:
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

func _on_ChaseArea_body_entered(body):
	if body.is_in_group("player"):
		is_chasing = true
		chase_target = body


func _on_ChaseArea_body_exited(body):
	if body.is_in_group("player"):
		is_chasing = false