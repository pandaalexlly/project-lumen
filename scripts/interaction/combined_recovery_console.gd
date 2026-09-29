class_name CombinedRecoveryConsole
extends Interactable

@export_node_path("CombinedTrialController") var trial_controller_path: NodePath

@onready var _trial_controller: CombinedTrialController = (
	get_node_or_null(trial_controller_path) as CombinedTrialController
)


func interact() -> void:
	if is_instance_valid(_trial_controller):
		_trial_controller.recover_from_failure()
		var presentation_ui := get_node_or_null("/root/PresentationUI")
		if presentation_ui != null:
			presentation_ui.call("show_notification", "EXPERIMENT STATE RESTORED")
