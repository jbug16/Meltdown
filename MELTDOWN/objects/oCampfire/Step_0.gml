// Check for overlapping projectile
var _p = instance_place(x, y, oHeatProjectile);
if (_p != noone) {
	instance_destroy(_p);
	hits_left--;
	
	if (hits_left <= 0) {
		// Burst pickups outward in a circle
		var _burst_speed = 5;
		var _angle_spread = 360 / drop_count;
		
		for (var i = 0; i < drop_count; i++) {
			var _angle = (i * _angle_spread) + random_range(-12, 12);
			var _speed = _burst_speed + random_range(0, 2);
			var _pickup = instance_create_layer(x, y, "Instances", oHeatPickup);
			
			_pickup.hsp = lengthdir_x(_speed, _angle);
			_pickup.vsp = lengthdir_y(_speed, _angle);
		}
		
		instance_destroy();
	}
}
