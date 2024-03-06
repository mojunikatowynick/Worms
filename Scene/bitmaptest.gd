extends Node2D

func _ready():
	
	$StaticBody2D/CollisionPolygon2D.polygon = $Polygon2D.polygon
	
func clip(poly):
	
	var offset_poly = Polygon2D.new()
	offset_poly.global_position = Vector2.ZERO
	
	var new_values = []
	for point in poly.polygon:
		new_values.append(point+poly.global_position)
	offset_poly = PackedVector2Array(new_values)
	
	var res = Geometry2D.clip_polygons($Polygon2D.polygon, offset_poly)
	
	$Polygon2D.polygon = res[0]
	$StaticBody2D/CollisionPolygon2D.set_deferred("polygon", res[0])
