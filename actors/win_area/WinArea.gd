extends Area2D

onready var typewriter = $Typewriter
onready var thank_you = $ThankYou

func _ready():
	typewriter.output_text = "The Earth rejects this sacrifice."
	thank_you.output_text = "Thanks for playing."
	typewriter.connect("typewriter_cleared", self, "load_next_text")

func _on_WinArea_body_entered(body):
	if body.is_in_group("player"):
		typewriter.print_text()
		
func load_next_text():
	thank_you.print_text()