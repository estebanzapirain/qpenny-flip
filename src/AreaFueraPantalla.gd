signal sale_de_pantalla

extends Area2D


func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _on_AreaFueraPantalla_body_enter_shape( body_id, body, body_shape, area_shape ):
    var coin = body
    if coin.state == 1:
        emit_signal("sale_de_pantalla")
