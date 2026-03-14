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

// Update pathfinding (always update direction, but movement depends on state)
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

// Creeper behavior: pause then burst
creeper_timer -= 1 / SECOND;

if (creeper_state == "pause") {
	// During pause: stop moving, just face the player
	if (target != noone) {
		var dir = point_direction(x, y, target.x, target.y);
		image_angle = dir;
	}
	
	// Decelerate to stop
	hsp = lerp(hsp, 0, decel);
	vsp = lerp(vsp, 0, decel);
	x += hsp;
	y += vsp;
	
	// When pause ends, switch to burst
	if (creeper_timer <= 0) {
		creeper_state = "burst";
		creeper_timer = burst_duration;
	}
} else if (creeper_state == "burst") {
	// During burst: move quickly toward player
	if (target != noone) {
		var dir = point_direction(x, y, target.x, target.y);
		target_hsp = lengthdir_x(burst_speed, dir);
		target_vsp = lengthdir_y(burst_speed, dir);
	} else {
		target_hsp = 0;
		target_vsp = 0;
	}
	
	// Apply movement with acceleration
	if (target_hsp != 0 || target_vsp != 0) {
		hsp = lerp(hsp, target_hsp, accel * 2.0);  // Faster acceleration during burst
		vsp = lerp(vsp, target_vsp, accel * 2.0);
		image_angle = point_direction(0, 0, hsp, vsp);
	}
	
	x += hsp;
	y += vsp;
	
	// When burst ends, switch back to pause
	if (creeper_timer <= 0) {
		creeper_state = "pause";
		creeper_timer = pause_duration;
	}
}

// Keep in room bounds
x = clamp(x, collision_radius, room_width - collision_radius);
y = clamp(y, collision_radius, room_height - collision_radius);

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

