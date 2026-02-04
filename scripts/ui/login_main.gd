extends Control

@export var register: VBoxContainer
@export var login: VBoxContainer

@export var register_button: Control
@export var login_button: Control


var nav_stack: Array[Control] = []
var current_panel

func _ready():
	
	login_button.pressed.connect(_navigate_to.bind(login))
	register_button.pressed.connect(_navigate_to.bind(register))


func _show_panel(panel: Control): 
	panel.visible = true

func _navigate_to(panel: Control): 
	if current_panel:
		nav_stack.append(current_panel)
		current_panel.visible = false

	current_panel = panel
	_show_panel(current_panel)
