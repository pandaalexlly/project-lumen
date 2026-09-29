extends Node

const LOG_DIRECTORY := "user://playtest"

var session_id: String = ""
var log_path: String = ""

var _active: bool = false
var _session_started_at_ms: int = 0
var _room_started_at_ms: int = 0
var _current_room: String = ""
var _completion_order: Array[String] = []
var _restart_counts: Dictionary = {}
var _failure_counts: Dictionary = {}
var _interaction_counts: Dictionary = {}
var _event_sequence: int = 0
var _file: FileAccess


func start_session(source: String = "main_menu") -> void:
	if _active:
		finish_session("new_session_started")

	_active = true
	_session_started_at_ms = Time.get_ticks_msec()
	_room_started_at_ms = 0
	_current_room = ""
	_completion_order.clear()
	_restart_counts.clear()
	_failure_counts.clear()
	_interaction_counts.clear()
	_event_sequence = 0

	var timestamp := Time.get_datetime_string_from_system(false, true).replace(":", "-").replace(" ", "_")
	session_id = "%s-%d" % [timestamp, _session_started_at_ms]
	log_path = "%s/session-%s.jsonl" % [LOG_DIRECTORY, session_id]
	_open_log_file()
	_record_event("session_started", {"source": source})


func record_room_entered(scene_path: String, title: String, order_index: int) -> void:
	_ensure_session("direct_stage")
	if scene_path == _current_room:
		_record_event(
			"room_reentered",
			{
				"room": scene_path,
				"title": title,
				"order_index": order_index,
				"elapsed_room_ms": _elapsed_room_ms(),
			}
		)
		return

	_current_room = scene_path
	_room_started_at_ms = Time.get_ticks_msec()
	_record_event(
		"room_entered",
		{"room": scene_path, "title": title, "order_index": order_index}
	)


func record_room_completed(scene_path: String, next_scene_path: String) -> void:
	_ensure_session("direct_stage")
	_completion_order.append(scene_path)
	_record_event(
		"room_completed",
		{
			"room": scene_path,
			"next_scene": next_scene_path,
			"completion_order": _completion_order.size(),
			"elapsed_room_ms": _elapsed_room_ms(),
		}
	)
	_current_room = ""
	_room_started_at_ms = 0


func record_restart(scene_path: String, reason: String) -> void:
	_ensure_session("direct_stage")
	_increment_count(_restart_counts, scene_path)
	_record_event(
		"room_restarted",
		{
			"room": scene_path,
			"reason": reason,
			"room_restart_count": _restart_counts[scene_path],
			"elapsed_room_ms": _elapsed_room_ms(),
		}
	)


func record_failed_attempt(scene_path: String, failure_id: String) -> void:
	_ensure_session("direct_stage")
	var failure_key := "%s|%s" % [scene_path, failure_id]
	_increment_count(_failure_counts, failure_key)
	_record_event(
		"failed_attempt",
		{
			"room": scene_path,
			"failure_id": failure_id,
			"failure_count": _failure_counts[failure_key],
			"elapsed_room_ms": _elapsed_room_ms(),
		}
	)


func record_interaction(scene_path: String, target: Interactable) -> void:
	_ensure_session("direct_stage")
	var interaction_key := "%s|%s" % [scene_path, target.interaction_label]
	_increment_count(_interaction_counts, interaction_key)
	var script_path := ""
	var target_script := target.get_script() as Script
	if target_script != null:
		script_path = target_script.resource_path
	_record_event(
		"interaction_used",
		{
			"room": scene_path,
			"target_name": target.name,
			"interaction_label": target.interaction_label,
			"script": script_path,
			"interaction_count": _interaction_counts[interaction_key],
			"elapsed_room_ms": _elapsed_room_ms(),
		}
	)


func finish_session(reason: String = "ending_reached") -> void:
	if not _active:
		return
	_record_event(
		"session_finished",
		{
			"reason": reason,
			"total_elapsed_ms": Time.get_ticks_msec() - _session_started_at_ms,
			"completion_order": _completion_order.duplicate(),
			"restart_counts": _restart_counts.duplicate(true),
			"failure_counts": _failure_counts.duplicate(true),
			"interaction_counts": _interaction_counts.duplicate(true),
		}
	)
	_active = false
	_current_room = ""
	_room_started_at_ms = 0
	_file = null


func get_snapshot() -> Dictionary:
	return {
		"active": _active,
		"session_id": session_id,
		"log_path": log_path,
		"current_room": _current_room,
		"completion_order": _completion_order.duplicate(),
		"restart_counts": _restart_counts.duplicate(true),
		"failure_counts": _failure_counts.duplicate(true),
		"interaction_counts": _interaction_counts.duplicate(true),
	}


func _ensure_session(source: String) -> void:
	if not _active:
		start_session(source)


func _elapsed_room_ms() -> int:
	if _room_started_at_ms == 0:
		return 0
	return Time.get_ticks_msec() - _room_started_at_ms


func _increment_count(counts: Dictionary, key: String) -> void:
	counts[key] = int(counts.get(key, 0)) + 1


func _open_log_file() -> void:
	_file = null
	var directory_path := ProjectSettings.globalize_path(LOG_DIRECTORY)
	var directory_error := DirAccess.make_dir_recursive_absolute(directory_path)
	if directory_error != OK and directory_error != ERR_ALREADY_EXISTS:
		push_warning("PlaytestTelemetry: could not create %s" % directory_path)
		return
	_file = FileAccess.open(log_path, FileAccess.WRITE)
	if _file == null:
		push_warning("PlaytestTelemetry: could not open %s" % log_path)


func _record_event(event_name: String, details: Dictionary) -> void:
	_event_sequence += 1
	var event := {
		"event": event_name,
		"sequence": _event_sequence,
		"session_id": session_id,
		"elapsed_session_ms": Time.get_ticks_msec() - _session_started_at_ms,
		"details": details,
	}
	if _file != null:
		_file.store_line(JSON.stringify(event))
		_file.flush()
