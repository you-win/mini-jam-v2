extends Label

#signals
signal finished_printing
signal typewriter_cleared

#variables
var output_text = ""
var is_finished_printing = false
var is_typing = false

onready var type_timer = $TypeTimer
onready var destruction_timer = $DestructionTimer

func _ready():
	pass

func print_text():
	if is_typing:
		return
	is_typing = true
	var temp_text_array = ""
	for character in output_text:
		type_timer.start()
		temp_text_array += character
		self.text = temp_text_array
		yield(type_timer, "timeout")
	
	emit_signal("finished_printing")
	is_finished_printing = true
	
	destruction_timer.start()

func _on_DestructionTimer_timeout():
	emit_signal("typewriter_cleared")
	self.queue_free()