extends Sprite

export var small_push = 100
export var big_push = 500

func _ready():
	$AnimationPlayer.current_animation = "explosion"

func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()

func _on_Hitbox2D_body_entered(body):
	if body.is_in_group("enemies"):
		var player = get_parent()
		var push_direction = (player.position - body.position).normalized()
		if push_direction.x > 0:
			player.linear_velocity.x += big_push
		elif push_direction.x < 0:
			player.linear_velocity.x -= big_push
		body.queue_free()
	if body.name == "TileMap":
		var random_direction = rand_range(-1, 1)
		var player = get_parent()
		if random_direction > 0:
			player.linear_velocity.x += small_push
		elif random_direction < 0:
			player.linear_velocity.x -= small_push
		if random_direction > 0.5:
			player.linear_velocity.y -= small_push
		elif random_direction < -0.5:
			player.linear_velocity.y -= small_push
	if body.is_in_group("not_player"):
		if body.is_dead:
			body.queue_free()