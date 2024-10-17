extends Node2D

@onready
#var _instance : BlockEditorContext = BlockEditorContext.new()
var _instance: BlockEditorContext = BlockEditorContext.get_default()
	
func _ready():
	print("Using default instance ", _instance)
	var MainPanel = get_node("../MainPanel")
	var lBlockCode = get_node("../BlockCode")
	await get_tree().create_timer(0.1).timeout
	MainPanel.switch_block_code_node(lBlockCode)
	MainPanel.undo_redo = null # UndoRedo.new()
	MainPanel.script_window_requested.connect(script_window_requested)

const ScriptWindow := preload("res://addons/block_code/ui/script_window/script_window.tscn")
func script_window_requested(scriptcontent):
	var script_window = ScriptWindow.instantiate()
	script_window.script_content = scriptcontent

	var parent: Node = get_parent()
	parent.add_child(script_window)

	await script_window.close_requested

	script_window.queue_free()
	script_window = null

	var script := GDScript.new()
	script.set_source_code(scriptcontent)
	script.reload()
	parent.set_script(script)
	parent._ready()
	#parent.set_process(true)
