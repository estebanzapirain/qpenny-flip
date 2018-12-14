signal suma_punto
signal resta_punto

extends Area2D


func _ready():
    pass
    


func _on_AreaFueraPantalla_body_enter( body ):
    if body.state == 1:  #body will be the coin
        emit_signal("suma_punto")
    else:  #body.state == 0
        emit_signal("resta_punto")


