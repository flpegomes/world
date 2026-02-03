extends Button

@onready var clip: Control = $Clip
@onready var highlight: TextureRect = $Clip/Highlight
@onready var label: Label = $Text

@export var highlight_extra_px := 140.0
@export var in_time := 0.16
@export var out_time := 0.10
@export var slide_from := 1.05

@export var label_idle := Color(0.85, 0.82, 0.76, 1.0)
@export var label_hover := Color(1, 1, 1, 1)

var tw: Tween

func _ready() -> void:
	# garante estado inicial
	label.modulate = label_idle
	_reflow()

	# hover + focus (teclado/controle)
	mouse_entered.connect(_on_enter)
	mouse_exited.connect(_on_exit)
	focus_entered.connect(_on_enter)
	focus_exited.connect(_on_exit)

	highlight.modulate.a = 0.0
	highlight.position.x = -highlight.size.x * slide_from

func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED:
		_reflow()

func _reflow() -> void:
	# Clip ocupa o botão inteiro e corta o highlight
	clip.size = size

	# highlight levemente maior pra parecer “pincel”
	highlight.size = Vector2(size.x + highlight_extra_px, size.y)
	highlight.position.y = 0

	# mantém “fora” se não estiver hover/focus
	if not (is_hovered() or has_focus()):
		highlight.position.x = -highlight.size.x * slide_from

func _kill_tween() -> void:
	if tw and tw.is_running():
		tw.kill()

func _on_enter() -> void:
	_kill_tween()
	tw = create_tween()
	tw.set_parallel(true)

	tw.tween_property(highlight, "position:x", 0.0, in_time)\
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	tw.tween_property(highlight, "modulate:a", 1.0, in_time * 0.9)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	tw.tween_property(label, "modulate", label_hover, in_time * 0.9)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func _on_exit() -> void:
	_kill_tween()
	tw = create_tween()
	tw.set_parallel(true)

	tw.tween_property(highlight, "position:x", -highlight.size.x * slide_from, out_time)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

	tw.tween_property(highlight, "modulate:a", 0.0, out_time)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

	tw.tween_property(label, "modulate", label_idle, out_time)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
