class_name INGAME_UI
extends Control

onready var hp_bar := $HpBar
onready var player_data := get_node("/root/Global/player_data")
onready var npc_data := get_node("/root/Global/npc_data")
var max_hp_bar_len = 52
var dialog_seq = null
var current_dialog = null
var current_profile = null
var is_option_open = false

signal paused()
signal option_picked()

func _on_pauseBtn_pressed():
	emit_signal("paused")

func _ready():
	set_dialog_seq( npc_data.get_dialog("Guz", "Level1_Intro") )

var t = 0; var i = .2
func _physics_process(delta):
	t+=delta
	if t >= i:
		t -= i
		lazy_update()


func lazy_update():
	hp_bar.margin_right = hp_bar.margin_left + max_hp_bar_len * player_data.get_hp_ratio();

func set_dialog_seq(seq: Array):
	dialog_seq = seq
	set_dialog(0)

func end_dialog():
	current_dialog = null
	$Dialog.visible = false

func set_dialog(i):
	if i == null:
		end_dialog()
	else:
		var dialog = dialog_seq[i]
		if dialog.has("profile"):
			current_profile = load(npc_data.profile_dict[dialog["profile"]] )
			$Dialog/Profile.texture = current_profile
		current_dialog = dialog
		if dialog.has("text"):
			$Dialog/Text.text = dialog["text"]


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
			if event.pressed && !is_option_open:
				if current_dialog.has("option"):
					set_dialog_option(current_dialog["option"])
					yield(self, "option_picked")
				else:
					set_dialog(current_dialog.get("next"))
