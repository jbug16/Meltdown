// Apply magnetic pull toward player when in range
if (instance_exists(oPlayer) && oPlayer.state == EntityState.Alive) {
	var _dist = point_distance(x, y, oPlayer.x, oPlayer.y);
	if (_dist <= oPlayer.magnet_range && _dist > 0) {
		var _dir_x = (oPlayer.x - x) / _dist;
		var _dir_y = (oPlayer.y - y) / _dist;
		hsp += _dir_x * oPlayer.magnet_strength;
		vsp += _dir_y * oPlayer.magnet_strength;
	}
}

// Single move and friction
x += hsp;
y += vsp;
hsp *= friction;
vsp *= friction;

// Collect on overlap
if (instance_exists(oPlayer) && oPlayer.state == EntityState.Alive) {
	if (place_meeting(x, y, oPlayer)) {
		player_add_heat(heat_amount);
		instance_destroy();
	}
}
