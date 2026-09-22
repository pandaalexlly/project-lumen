extends ObservableObject


func _on_observation_started() -> void:
	print("Observation test: OBSERVED")


func _on_observation_ended() -> void:
	print("Observation test: NOT OBSERVED")
