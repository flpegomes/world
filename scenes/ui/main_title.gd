extends Control

@onready var my_label: Label = $MinhaLabel
var pulse_tween: Tween

@export var scale_min := 0.95
@export var scale_max := 1.05
@export var duration := 0.6

func _ready() -> void:
	start_pulse()

func start_pulse() -> void:
	stop_pulse()

	# garante que vai escalar a partir do centro
	my_label.pivot_offset = my_label.size * 0.5

	pulse_tween = create_tween()
	pulse_tween.set_loops() # infinito
	pulse_tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	# vai e volta
	pulse_tween.tween_property(my_label, "scale", Vector2.ONE * scale_max, duration)
	pulse_tween.tween_property(my_label, "scale", Vector2.ONE * scale_min, duration)

func stop_pulse() -> void:
	if pulse_tween and pulse_tween.is_running():
		pulse_tween.kill()
