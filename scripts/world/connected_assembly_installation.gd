extends Node3D


func _ready() -> void:
	var return_beam := $ReturnBeam as StabilizationBeam
	var return_target := $BeamTargets/RBTarget as Marker3D
	return_beam.aim_at(return_target.global_position)
