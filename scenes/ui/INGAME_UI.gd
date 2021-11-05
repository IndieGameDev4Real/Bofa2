class_name INGAME_UI
extends Control

onready var hp_bar := $HpBar
onready var player_data := get_node("/root/Global/player_data")
onready var npc_data := get_node("/root/Global/npc_data")
onready var global = get_node("/root/Global")
var max_hp_bar_len = 52
var dialog_seq = null
var current_dialog_frame = null
var current_profile = null
var is_option_open = false

signal paused()
signal option_picked()

func _on_pauseBtn_pressed():
	emit_signal("paused")

func _ready():
	start_dialog( "Guz", "Level1_Intro" )



func lazy_update():
	hp_bar.margin_right = hp_bar.margin_left + max_hp_bar_len * player_data.get_hp_ratio();

func start_dialog(npc: String, name: String): 
	var dialog_data = npc_data.get_dialog(npc, name)

	dialog_seq = dialog_data["sequence"]
	
	set_dialog(0)

func end_dialog():
	current_dialog_frame = null
	$Dialog.visible = false

func resolve_text(dialog: Dictionary) -> String:
	var txt = dialog["text"]

	var expr = Expression.new()
	if "vars" in dialog:
		var resolved_vars = []
		for _var in dialog.get("vars"):
			expr.parse(_var)
			resolved_vars.push_back(expr.execute([], global))
		txt = txt % resolved_vars
	return txt

# assumes dialog has "cond" key
func resolve_condition( dialog: Dictionary, recursive = true ) -> Dictionary:
	var expr = Expression.new()
	var cond: Array = dialog["cond"]
	var new_dialog = cond.back()
	
	for case in cond:
		if "expr" in case:
			expr.parse(case["expr"])
			print_debug(case)
			var res = expr.execute([], global)
			if res == true:
				new_dialog = case
				break
	
	if recursive && "cond" in new_dialog:
		new_dialog = resolve_condition(new_dialog)
	return new_dialog

func set_dialog(i):
	if i == null:
		end_dialog()
	else:
		var dialog = dialog_seq[i]
		
		if "profile" in dialog:
			current_profile = load(npc_data.profile_dict[dialog["profile"]] )
			$Dialog/Profile.texture = current_profile
			
		while "cond" in dialog:
			dialog = resolve_condition(dialog)
		
		if "text" in dialog:
			$Dialog/Text.text = resolve_text( dialog )
		
		current_dialog_frame = dialog


func set_dialog_option(option: Array):
	$Dialog/Text.text = ""
	var count = len(option)
	for i in range(count):
		is_option_open = true
		var btn = Button.new()
		btn.text = option[i]["text"]
		btn.connect("button_down", self, "_on_option_selected", [option[i]], CONNECT_ONESHOT)
		$Dialog/OptionContainer.call_deferred("add_child", btn)


func _on_option_selected(option):
	emit_signal("option_picked")
	is_option_open = false
	set_dialog(option["next"])
	for child in $Dialog/OptionContainer.get_children():
		child.queue_free()


func _on_Dialog_gui_input(event):
	get_tree().set_input_as_handled()
	if dialog_seq != null:
		if event is InputEventMouseButton:
			if event.pressed && not is_option_open:
				if current_dialog_frame.has("option"):
					set_dialog_option(current_dialog_frame["option"])
					yield(self, "option_picked")
				else:
					set_dialog(current_dialog_frame.get("next"))


