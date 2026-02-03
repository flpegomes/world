extends Control
class_name ButtonFX

signal pressed

@export var text: String = "Button" : set = set_text
@export var fill_color: Color = Color(0.29, 0.55, 0.42, 1.0) : set = set_fill_color
@export var text_color: Color = Color(1,1,1) : set = set_text_color
@export var hover_text_color: Color = Color(1,1,1)  # opcional
@onready var button_fx: ButtonFX = $"."

@onready var button: Button = $Button
@onready var fill: ColorRect = $Button/Fill
@onready var label: Label = $Button/MarginContainer/Label

var tween: Tween
var mat: ShaderMaterial

func _ready() -> void:
	mat = fill.material as ShaderMaterial
	set_text(text)
	set_fill_color(fill_color)
	set_text_color(text_color)

	button.mouse_entered.connect(_on_enter)
	button.mouse_exited.connect(_on_exit)
	button.pressed.connect(func(): emit_signal("pressed"))

	# começa vazio
	if mat:
		mat.set_shader_parameter("fill_amount", 0.0)

func set_text(v: String) -> void:
	text = v
	if is_node_ready():
		label.text = v

func set_fill_color(c: Color) -> void:
	fill_color = c
	if is_node_ready() and mat:
		# troque o nome do uniform conforme seu shader:
		# cor_tinta ou cor_spray
		mat.set_shader_parameter("cor_tinta", c)

func set_text_color(c: Color) -> void:
	text_color = c
	if is_node_ready():
		label.add_theme_color_override("font_color", c)

func _on_enter() -> void:
	label.add_theme_color_override("font_color", hover_text_color)
	button_fx.rotation_degrees = -3
	_animate_fill(1.0, 0.25)

func _on_exit() -> void:
	label.add_theme_color_override("font_color", text_color)
	_animate_fill(0.0, 0.20)
	button_fx.rotation_degrees = 0


func _animate_fill(target: float, dur: float) -> void:
	if not mat:
		return
	if tween and tween.is_running():
		tween.kill()

	var cur := float(mat.get_shader_parameter("fill_amount"))
	tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(mat, "shader_parameter/fill_amount", target, dur).from(cur)
