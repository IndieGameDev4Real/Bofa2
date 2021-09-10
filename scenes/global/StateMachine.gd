class_name StateMachine
extends Node

signal state_changed(state, prev)

const DEBUG = true

var state: Node

var history = []

var _log: Log = null

func _ready():
	if owner.has_node("Log"):
		_log = owner.get_node("Log")
	
	state = get_child(0)
	emit_signal("state_changed", state, null)
	_enter_state()
	
func change_to(new_state):
	history.append(state.name)
	state = get_node(new_state)
	emit_signal("state_changed", state, null)
	_enter_state()

func back():
	if history.size() > 0:
		var new_state = get_node(history.pop_back())
		emit_signal("state_changed", new_state, state)
		state = new_state
		_enter_state()

func _enter_state():
		
	if DEBUG and _log != null: _log.add_log([ owner.name + "> Entering state: ", state.name])
	state.fsm = self
	state.enter()

# Route Game Loop function calls to
# current state handler method if it exists
func _process(delta):
	if state.has_method("process"):
		state.process(delta)

func _physics_process(delta):
	if state.has_method("physics_process"):
		state.physics_process(delta)

func _input(event):
	if state.has_method("input"):
		state.input(event)

func _unhandled_input(event):
	if state.has_method("unhandled_input"):
		state.unhandled_input(event)

func _unhandled_key_input(event):
	if state.has_method("unhandled_key_input"):
		state.unhandled_key_input(event)

func try_call_func(name: String, argv: Array = []):
	return state.callv(name, argv)

