extends Control
signal noQuit()

## Called when the node enters the scene tree for the first time.
#func _ready():
	#pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass


func _on_yes_btn_pressed():
	get_tree().quit()


func _on_no_btn_pressed():
	noQuit.emit()
