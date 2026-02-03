extends Control

@onready var background = $Background
@onready var label = $Label

# Configurações da animação
var largura_normal = 50.0
var largura_hover = 200.0
var velocidade_animacao = 0.15

# Cores
var cor_normal = Color(0.23, 0.43, 0.35, 0.5)
var cor_hover = Color(0.29, 0.55, 0.42, 1.0)

# Estado atual
var esta_hover = false
var esta_animando = false

func _ready():
	background.size.x = largura_normal
	background.color = cor_normal
	
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	mouse_filter = Control.MOUSE_FILTER_PASS
	
	# IMPORTANTE: Define o mouse_filter dos filhos para IGNORE
	# Isso evita que eles interfiram nos eventos de mouse
	for child in get_children():
		if child is Control:
			child.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _on_mouse_entered():
	# Só anima se não estiver em hover E não estiver animando
	if not esta_hover and not esta_animando:
		esta_hover = true
		animar_background(largura_hover, cor_hover)

func _on_mouse_exited():
	# Só anima se estiver em hover E não estiver animando
	if esta_hover and not esta_animando:
		esta_hover = false
		animar_background(largura_normal, cor_normal)

func animar_background(largura_alvo: float, cor_alvo: Color):
	# Marca que está animando
	esta_animando = true
	
	# Cria novo Tween
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_parallel(true)
	
	# Anima largura e cor simultaneamente
	tween.tween_property(background, "size:x", largura_alvo, velocidade_animacao)
	tween.tween_property(background, "color", cor_alvo, velocidade_animacao)
	
	# Quando terminar, marca que não está mais animando
	tween.finished.connect(func(): esta_animando = false)
