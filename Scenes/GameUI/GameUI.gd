extends Control


onready var level_container = $LevelsContainer
onready var shadow_panel = $ShadowPanel
onready var modal_panel = $CenterContainer/ModalPanel

var current_level : int = 0
var love : float = 100.0
var happiness : float = 100.0
var appearance : float = 100.0

func start_game():
	start_current_level()

func advance_level():
	current_level += 1
	start_current_level()

func start_current_level():
	var level_ui = level_container.get_child(current_level)
	level_ui.show()
	level_ui.start_level()
	if level_ui.has_signal("day_ended"):
		level_ui.connect("day_ended", self, "_on_Level_day_ended", [level_ui])
	if level_ui.has_signal("happiness_affected"):
		level_ui.connect("happiness_affected", self, "_on_Level_happiness_affected")
	if level_ui.has_signal("apperance_affected"):
		level_ui.connect("apperance_affected", self, "_on_Level_apperance_affected")

func _on_Level_day_ended(level_ui : Node):
	level_ui.hide()
	shadow_panel.show()
	modal_panel.show()

func _on_Level_happiness_affected(amount : float):
	happiness += amount
	$Control/Panel/MarginContainer/VBoxContainer/HappinessLabel.text = "Happiness : %.0f" % happiness

func _on_Level_apperance_affected(amount : float):
	appearance += amount

func _on_Button_pressed():
	modal_panel.hide()
	shadow_panel.hide()
	advance_level()

func _ready():
	$Control/Panel/MarginContainer/VBoxContainer/LoveLabel.text = "Love : %.0f" % love
	$Control/Panel/MarginContainer/VBoxContainer/HappinessLabel.text = "Happiness : %.0f" % happiness


