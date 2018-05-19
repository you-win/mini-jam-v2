extends KinematicBody2D

#constants
const GRAVITY_VECTOR = Vector2(0, 500)
const FLOOR_NORMAL = Vector2(0, -1)
const SLOPE_SLIDE_STOP = 10.0
const MIN_AIR_TIME = 0.1 
const H_ANIMATION_CHANGE = 10

#variables
var linear_velocity = Vector2()
var air_time = 0 #track how long object is in the air
var is_grounded = false
var state
var animation

func _physics_process(delta):
	#counter
	air_time += delta
  
	#ground detection
	if(is_on_floor()):
		air_time = 0
	is_grounded = air_time < MIN_AIR_TIME #small leeway for bumps
  
	#gravity
	linear_velocity += delta * GRAVITY_VECTOR
	linear_velocity = move_and_slide(linear_velocity, FLOOR_NORMAL, SLOPE_SLIDE_STOP)

func change_state(new_state):
	state = new_state