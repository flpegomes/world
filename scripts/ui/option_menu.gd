extends Control

var tween: Tween
@onready var button: Button = $Button
@onready var fill: ColorRect = $Button/Highlight
@onready var text: Label = $Button/MarginContainer/Label

func _ready() -> void:
	# garante texto por cima do fill

	fill.mouse_filter = Control.MOUSE_FILTER_IGNORE
	text.mouse_filter = Control.MOUSE_FILTER_IGNORE

	# começa sem preenchimento
	var mat := fill.material as ShaderMaterial
	mat.set_shader_parameter("fill_amount", 0.0)

func hover_on() -> void:
	_kill_tween()

	var mat := fill.material as ShaderMaterial
	var cur := float(mat.get_shader_parameter("fill_amount"))
	set_label_color(Color.BLACK)

	tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(mat, "shader_parameter/fill_amount", 1.0, 0.25).from(cur)

func hover_off() -> void:
	_kill_tween()

	var mat := fill.material as ShaderMaterial
	var cur := float(mat.get_shader_parameter("fill_amount"))
	set_label_color(Color.WHITE)


	tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(mat, "shader_parameter/fill_amount", 0.0, 0.20).from(cur)

func _kill_tween() -> void:
	if tween and tween.is_running():
		tween.kill()

func set_label_color(c: Color) -> void:
	text.add_theme_color_override("font_color", c)

func _on_button_mouse_entered() -> void:
	hover_on()

func _on_button_mouse_exited() -> void:
	hover_off()
