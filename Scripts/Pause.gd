extends TextureButton


func _pressed():
	if !get_tree().is_paused():
		get_tree().set_pause(true)
		set_texture_normal(load("res://Assets/play.png"))
	elif get_tree().is_paused():
		get_tree().set_pause(false)
		set_texture_normal(load("res://Assets/pause.png"))