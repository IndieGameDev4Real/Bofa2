extends Node

var dialog_dict = {}
var profile_dict = {}

func _enter_tree():
	var dialog_file = File.new()
	dialog_file.open("res://scenes/global/dialog.json", File.READ)
	var raw_json_text = dialog_file.get_as_text()
	var json_parse_result = JSON.parse(raw_json_text)
	if json_parse_result.error != 0:
		print("failed to parse dialog")
		print("\t%d" % json_parse_result.error_line)
		print("\t%s" % json_parse_result.error_string)
	else:
		dialog_dict = json_parse_result.result["dialog"]
		profile_dict = json_parse_result.result["profiles"]



func get_dialog(npc_name: String, dialog_name: String):
	var npc = dialog_dict[npc_name]
	if npc != null:
		var dialog = npc[dialog_name]
		if dialog != null:
			return dialog
