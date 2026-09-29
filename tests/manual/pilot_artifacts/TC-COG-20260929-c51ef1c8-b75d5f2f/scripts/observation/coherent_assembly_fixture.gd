extends Node3D


func _ready() -> void:
	($StabilizationBeam as StabilizationBeam).aim_at(
		$ConfigurationA.global_transform * Vector3(0, 0.65, -1.2)
	)
	($BeamB as StabilizationBeam).aim_at(
		$ConfigurationB.global_transform * Vector3(0, 0.65, -1.2)
	)
	($BeamC as StabilizationBeam).aim_at(
		$ConfigurationC.global_transform * Vector3(0, 0.65, -1.2)
	)
