extends Control


onready var jobs_container = $VBoxContainer

var jobs_list : Array = []

func _ready():
	for child in jobs_container.get_children():
		if child.has_signal("job_started"):
			child.connect("job_started", self, "_on_JobPanel_job_started", [child])
		if child.has_signal("job_completed"):
			child.connect("job_completed", self, "_on_JobPanel_job_completed", [child])
		jobs_list.append(child)

func _on_JobPanel_job_started(node : Node):
	for child in jobs_list:
		if child != node and child.has_method("stop_job"):
			child.stop_job()

func _on_JobPanel_job_completed(node : Node):
	jobs_list.erase(node)
