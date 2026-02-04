extends Control

# HUD Panels
@onready var settings_panel: Panel = $"Settings Panel"
@onready var settings_teste: Panel = $"Settings Teste"

# HUD Buttons
@onready var teste_button: Button = $Menu/Teste
@onready var settings_button: Button = $Menu/Settings


func _ready():
	var group_main_buttons = ButtonGroup.new()
	group_main_buttons.allow_unpress = true
	
	settings_button.button_group = group_main_buttons
	teste_button.button_group = group_main_buttons

func _on_settings_toggled(toggled_on: bool) -> void:
	settings_panel.visible = toggled_on

func _on_teste_toggled(toggled_on: bool) -> void:
	settings_teste.visible = toggled_on
