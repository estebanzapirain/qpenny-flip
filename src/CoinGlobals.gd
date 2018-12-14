extends Node

const COIN_WIDHT = 100

var min_CPU_Try_WT
var max_CPU_Try_WT
var had_PU_on = false

func _ready():
	pass

func setMin_CPU_Try_WT(value):
	min_CPU_Try_WT = value

func setMax_CPU_Try_WT(value):
	max_CPU_Try_WT = value

func getMin_CPU_Try_WT():
	return min_CPU_Try_WT

func getMax_CPU_Try_WT():
	return max_CPU_Try_WT

func setHad_PU_on(cond):
	had_PU_on = cond

func isHad_PU_on():
	return had_PU_on