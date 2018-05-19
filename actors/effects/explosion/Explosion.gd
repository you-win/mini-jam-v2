extends Sprite

func _ready():
	$AnimationPlayer.current_animation = "explosion"

func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()