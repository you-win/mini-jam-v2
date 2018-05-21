extends "res://general_scripts/PhysicsObject.gd"

#public vars
export var output_text = ""

#constants
const H_ACCELERATION = .1

#variables
var is_dead = false

onready var sprite = $Sprite
onready var animation_player = $AnimationPlayer
onready var self_destruct_sound = $SelfDestructSound
onready var landing_sound = $LandingSound
onready var typewriter = $Typewriter

var player = null

func _ready():
	animation_player.current_animation = "idle"
	typewriter.output_text = output_text
	pass

func _physics_process(delta):
	linear_velocity.x = lerp(linear_velocity.x, 0, H_ACCELERATION)
	if player != null:
		var face_direction = (player.position - self.position).normalized()
		if face_direction.x > 0:
			sprite.scale.x = 1
		elif face_direction.x < 0:
			sprite.scale.x = -1
		if(typewriter.is_finished_printing):
			animation_player.current_animation = "self_destruct"

func _on_DetectPlayer_body_entered(body):
	if body.is_in_group("player"):
		player = body
		typewriter.print_text()

func play_self_destruct_sound():
	self_destruct_sound.play(0)
	get_node("DetectPlayer").queue_free()
	player = null
	
func play_landing_sound():
	landing_sound.play(0)
	is_dead = true