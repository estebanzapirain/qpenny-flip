tool
extends Node


const black = Vector2(1.0,0.0)
const white = Vector2(0.0,1.0)
const superposition = Vector2(1/sqrt(2),1/sqrt(2))



export var qstate = black setget qstate_set, qstate_get

func qstate_set(state):
	qstate = state

func qstate_get():
	return qstate
	
func qstate_show():
	print(qstate)

func h_gate():
	qstate = superposition
	qstate_show()