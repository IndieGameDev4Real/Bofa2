class_name Log
extends Control

var lines = []

func update_text():
	var text = ""
	
	for line in lines:
		text = text + line + "\n"
	$text.text = text

func add_log(line):
	if line is Array:
		var string = ""
		for l in line:
			string += String(l)
		lines.push_front(string)
	if len(lines) >= 5:
		lines.pop_back()
	update_text()
