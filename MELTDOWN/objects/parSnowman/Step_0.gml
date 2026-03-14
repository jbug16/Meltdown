// Ignore if dead
if (state == EntityState.Dead) exit;

// Update target if needed
if (!instance_exists(target) || target.state == EntityState.Dead) {
	find_target();
}

// If no target, idle
if (target == noone) {
	// Decelerate to stop
	hsp = lerp(hsp, 0, decel);
	vsp = lerp(vsp, 0, decel);
	x += hsp;
	y += vsp;
	exit;
}

// Update pathfinding
pathfinding_timer -= 1 / SECOND;
if (pathfinding_timer <= 0 && pathfinding_active) {
	update_pathfinding();
	pathfinding_timer = pathfinding_update_rate;
}

// Apply knockback from hits
if (hit_knockback_timer > 0) {
	var knockback_decay = 0.75; 
	x += hit_knockback_x;
	y += hit_knockback_y;
	hit_knockback_x *= knockback_decay;
	hit_knockback_y *= knockback_decay;
	hit_knockback_timer -= 1 / SECOND;
	
	if (hit_knockback_timer <= 0) {
		hit_knockback_x = 0;
		hit_knockback_y = 0;
	}
}

// Movement
update_movement();

// Separate from other enemies to prevent overlapping
separate_from_enemies();

// Attack system
attack_timer -= 1 / SECOND;
if (attack_timer <= 0) {
	can_attack = true;
}

var dist_to_target = point_distance(x, y, target.x, target.y);
if (can_attack && dist_to_target <= attack_range) {
	perform_attack();
}

// Freeze ground system
if (freeze_ground) {
	freeze_timer -= 1 / SECOND;
	if (freeze_timer <= 0) {
		create_frozen_ground();
		freeze_timer = freeze_update_rate;
	}
}

// Update visual effects (melting)
update_visuals();