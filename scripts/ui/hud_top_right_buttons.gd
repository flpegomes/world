extends TextureButton

@export var hover_scale := 1
@export var press_scale := 0.98

@export var hover_brightness := 0.60
@export var press_brightness := 0.3

var _tween: Tween

func _ready():
	pivot_offset = size * 0.5

	mouse_entered.connect(_on_enter)
	mouse_exited.connect(_on_exit)
	button_down.connect(_on_down)
	button_up.connect(_on_up)

func _kill_tween():
	if _tween and _tween.is_running():
		_tween.kill()

func _animate(to_brightness: float, dur := 0):
	_kill_tween()
	_tween = create_tween()
	_tween.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

	_tween.tween_property(self, "scale", Vector2.ONE, dur)

	var c := Color.WHITE * to_brightness
	c.a = modulate.a
	_tween.tween_property(self, "modulate", c, dur)

func _on_enter():
	_animate(hover_brightness, 0.12)

func _on_exit():
	_animate(1.0, 0.12)

func _on_down():
	_animate(press_brightness, 0.06)

func _on_up():
	# se ainda está em hover, volta pro hover; se não, volta pro normal
	if get_rect().has_point(get_local_mouse_position()):
		_animate(hover_brightness, 0.08)
	else:
		_animate(1.0, 0.10)
