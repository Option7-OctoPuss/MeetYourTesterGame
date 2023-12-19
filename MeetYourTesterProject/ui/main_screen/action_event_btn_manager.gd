extends TextureButton

var state_disabled = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	print("action event is timeout")
	state_disabled = !state_disabled
	self.set_disabled(state_disabled)

