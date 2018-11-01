tool
extends Node

export var qstate = [1.0 0.0] setget qstate_set, qstate_get

func qstate_set(state)):
	qstate = state

func qstate_get():
	return qstate
	
func qstate_show():
	print(qstate)
