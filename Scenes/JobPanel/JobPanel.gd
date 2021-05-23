tool
extends Control


signal job_started
signal job_completed
signal task_completed
signal milestone_completed
signal happiness_affected(amount)
signal appearance_affected(amount)

export(String) var job_name : String = "Name of the Chore" setget set_job_name
export(int, 1, 100) var task_count : int = 10
export(float, 0.0, 60.0) var task_time : float = 0.5
export(float, -5.0, 5.0) var happiness_affect : float = 0.0
export(float, -5.0, 5.0) var appearance_affect : float = 0.0
export(StyleBox) var panel_normal : StyleBox
export(StyleBox) var panel_hover : StyleBox
export(StyleBox) var panel_active : StyleBox

var active : bool = false
var job_completed : bool = false
var tasks_completed : int = 0

func set_job_name(value : String) :
	job_name = value
	if is_inside_tree():
		$Panel/MarginContainer/HBoxContainer/Center/Label.text = job_name

func is_active():
	return active

func is_job_completed():
	return job_completed

func set_panel_normal():
	if panel_normal:
		$Panel.set("custom_styles/panel", panel_normal)

func set_panel_active():
	if panel_active:
		$Panel.set("custom_styles/panel", panel_active)

func set_panel_hover():
	if panel_hover:
		$Panel.set("custom_styles/panel", panel_hover)

func start_job():
	if is_active():
		return
	active = true
	$Panel/MarginContainer/HBoxContainer/Center/ProgressBar.max_value = task_count
	$Panel/MarginContainer/HBoxContainer/Center/TaskClock.start(task_time)
	set_panel_active()
	emit_signal("job_started")

func stop_job():
	if not is_active():
		return
	active = false
	$Panel/MarginContainer/HBoxContainer/Center/TaskClock.stop()
	set_panel_normal()

func complete_job():
	if is_job_completed():
		return
	emit_signal("job_completed")
	job_completed = true
	$Panel/MarginContainer/HBoxContainer/Center/TaskClock.stop()
	$AnimationPlayer.play("JobComplete")
	yield($AnimationPlayer, "animation_finished")
	queue_free()

func complete_task():
	tasks_completed += 1
	$Panel/MarginContainer/HBoxContainer/Center/ProgressBar.value = tasks_completed
	emit_signal("happiness_affected", happiness_affect)
	emit_signal("appearance_affected", appearance_affect)
	if tasks_completed >= task_count:
		complete_job()

func _on_JobPanel_mouse_entered():
	set_panel_hover()

func _on_JobPanel_mouse_exited():
	if is_active():
		set_panel_active()
	else:
		set_panel_normal()

func _on_JobPanel_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == BUTTON_LEFT:
			start_job()

func _on_TaskClock_timeout():
	complete_task()

func _ready():
	set_job_name(job_name)
