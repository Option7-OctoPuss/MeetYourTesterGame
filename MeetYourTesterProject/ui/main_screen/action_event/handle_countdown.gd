extends Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	self.wait_time = 2
	self.start()

func _process(_delta):
	send_time_to_label()

func send_time_to_label():
	get_parent().text = str(self.time_left).substr(0, 3)