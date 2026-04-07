if (game_is_paused()) exit;

// Check for nearby enemies - if enemies nearby, don't melt
var nearby_enemy = noone;
with (parSnowman) {
	if (point_distance(x, y, other.x, other.y) <= other.enemy_protection_range) {
		nearby_enemy = id;
		break;
	}
}

// Only decay if no enemies nearby
if (nearby_enemy == noone) {
	var melt_multiplier = 1.0;
	
	// Check for nearby projectiles - melt slower when projectiles are near
	var nearby_projectile = noone;
	with (oHeatProjectile) {
		var dist = point_distance(x, y, other.x, other.y);
		if (dist <= other.projectile_slow_range) {
			nearby_projectile = id;
			melt_multiplier = other.projectile_slow_multiplier;
			break;
		}
	}
	
	// Check for nearby campfires - melt faster if near heat source (only if no projectile slowing)
	if (nearby_projectile == noone) {
		with (oCampfire) {
			var dist = point_distance(x, y, other.x, other.y);
			if (dist <= other.campfire_melt_range) {
				melt_multiplier = other.campfire_melt_multiplier;
				break;
			}
		}
	}
	
	// Decay lifetime (slower if near projectile, faster if near campfire)
	lifetime -= 1 * melt_multiplier;
}

// Fade out as it expires (last 20% of initial lifetime)
var fade_start = initial_duration * SECOND * 0.2;
if (lifetime <= fade_start) {
	var fade_progress = lifetime / fade_start;
	image_alpha = 0.6 * fade_progress;
}

// Destroy when timer expires
if (lifetime <= 0) {
	instance_destroy();
}
