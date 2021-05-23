extends Control


signal day_ended
signal job_completed
signal happiness_affected(amount)
signal apperance_affected(amount)

export(float, 0.0, 120.0) var day_length : float = 15.0

onready var jobs_container = $VBoxContainer/ScrollContainer/JobsContainer
onready var clean_progress = $VBoxContainer/Control/CleanProgressBar
onready var day_clock = $VBoxContainer/Control/DayClock

var jobs_list : Array = []

func _ready():
	for child in jobs_container.get_children():
		if child.has_signal("job_started"):
			child.connect("job_started", self, "_on_JobPanel_job_started", [child])
		if child.has_signal("job_completed"):
			child.connect("job_completed", self, "_on_JobPanel_job_completed", [child])
		if child.has_signal("happiness_affected"):
			child.connect("happiness_affected", self, "_on_JobPanel_happiness_affected")
		if child.has_signal("appearance_affected"):
			child.connect("appearance_affected", self, "_on_JobPanel_appearance_affected")
		jobs_list.append(child)
	$VBoxContainer/Control/DayClock.wait_time = day_length

func stop_all_jobs():
	for child in jobs_list:
		if child.has_method("stop_job"):
			child.stop_job()

func start_level():
	day_clock.start()

func stop_level():
	stop_all_jobs()
	day_clock.stop()

func pause_level():
	day_clock.pause()

func unpause_level():
	day_clock.unpause()

func _on_JobPanel_job_started(node : Node):
	for child in jobs_list:
		if child != node and child.has_method("stop_job"):
			child.stop_job()

func _on_JobPanel_job_completed(node : Node):
	jobs_list.erase(node)
	clean_progress.value += 1
	emit_signal("job_completed")

func _on_JobPanel_happiness_affected(amount : float):
	emit_signal("happiness_affected", amount)

func _on_JobPanel_appearance_affected(amount : float):
	emit_signal("appearance_affected", amount)

func _on_DayClock_timeout():
	stop_level()
	emit_signal("day_ended")

func _process(delta):
	var time_left : float = $VBoxContainer/Control/DayClock/Timer.time_left
	$VBoxContainer/Control/DayClockLabel.text = "%1.2f" % time_left
