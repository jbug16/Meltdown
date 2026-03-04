/// @description Find and set target (player). Returns target instance or noone.
/// @return {instance} Target instance or noone
function find_target() {
	// TODO: simplify?
	target = instance_find(oPlayer, 0);
	if (instance_exists(target) && target.state == EntityState.Alive) {
		return target;
	}
	target = noone;
	return noone;
}

/// @description Update pathfinding - simple direct movement to target
function update_pathfinding() {
	if (target == noone) {
		target_hsp = 0;
		target_vsp = 0;
		return;
	}
	
	var dist = point_distance(x, y, target.x, target.y);
	
	// Only pathfind if within range
	if (dist > pathfinding_range) {
		target_hsp = 0;
		target_vsp = 0;
		return;
	}
	
	// Simple direct pathfinding
	var dir = point_direction(x, y, target.x, target.y);
	target_hsp = lengthdir_x(move_speed, dir);
	target_vsp = lengthdir_y(move_speed, dir);
}

/// @description Update movement with acceleration/deceleration
function update_movement() {
	if (target == noone) {
		target_hsp = 0;
		target_vsp = 0;
	}
	
	// Apply acceleration/deceleration (Brotato-style)
	if (target_hsp != 0 || target_vsp != 0) {
		hsp = lerp(hsp, target_hsp, accel);
		vsp = lerp(vsp, target_vsp, accel);
		image_angle = point_direction(0, 0, hsp, vsp);
	} else {
		hsp = lerp(hsp, 0, decel);
		vsp = lerp(vsp, 0, decel);
	}
	
	// Apply movement
	x += hsp;
	y += vsp;
	
	// Keep in room bounds 
	x = clamp(x, collision_radius, room_width - collision_radius);
	y = clamp(y, collision_radius, room_height - collision_radius);
}

/// @description Perform attack on target (deals damage to player)
function perform_attack() {
	if (target == noone || !can_attack) return;
	
	// Deal damage to player
	if (instance_exists(target)) {
		player_damage(attack_damage);
	}
	
	// Reset attack cooldown
	can_attack = false;
	attack_timer = attack_cooldown;
}

/// @description Update visual effects (melting based on health)
function update_visuals() {
	// Update health percentage
	health_percentage = hp / max_hp;
	
	// Scale sprite based on health (melting effect)
	sprite_scale = base_sprite_scale * (0.5 + 0.5 * health_percentage);
	image_xscale = sprite_scale;
	image_yscale = sprite_scale;
	
	// Hit flash
	if (hit_flash_timer > 0) {
		// Flash bright white/red tint for visibility
		var flash_intensity = hit_flash_timer / hit_flash_duration;
		
		// Use bright red tint for more visible flash
		image_blend = make_color_rgb(255, 150 + (105 * flash_intensity), 150 + (105 * flash_intensity));
	
		// Slightly increase alpha during flash for brightness
		var base_alpha = 0.7 + 0.3 * health_percentage;
		image_alpha = min(1.0, base_alpha + 0.2 * flash_intensity);
		hit_flash_timer -= 1 / SECOND;
	} else {
		// Restore color and alpha
		image_blend = c_white;
		image_alpha = 0.7 + 0.3 * health_percentage;
	}
}

/// @description Take damage and handle death
/// @param {real} amount Damage amount
/// @param {real} projectile_dir Direction of projectile
function take_damage(amount, projectile_dir = -1) {
	if (state == EntityState.Dead) return;
	
	hp -= amount;
	hp = max(0, hp);
	
	// Trigger hit feedback effects
	trigger_hit_feedback(amount, projectile_dir);
	
	if (hp <= 0) {
		die();
	}
}

/// @description Trigger hit feedback effects (flash, knockback)
/// @param {real} damage_amount Amount of damage taken
/// @param {real} projectile_dir Direction of projectile
function trigger_hit_feedback(damage_amount, projectile_dir) {
	// Hit flash
	hit_flash_timer = hit_flash_duration;
	
	// Knockback (push enemy away in the direction the projectile is traveling)
	if (projectile_dir >= 0) {
		// Use projectile direction directly
		hit_knockback_x = lengthdir_x(hit_knockback_strength, projectile_dir);
		hit_knockback_y = lengthdir_y(hit_knockback_strength, projectile_dir);
	} else {
		// Default knockback away from player if projectile direction not available
		if (instance_exists(target)) {
			var dir_to_enemy = point_direction(target.x, target.y, x, y);
			hit_knockback_x = lengthdir_x(hit_knockback_strength, dir_to_enemy);
			hit_knockback_y = lengthdir_y(hit_knockback_strength, dir_to_enemy);
		}
	}
	
	hit_knockback_timer = hit_knockback_duration;
}

/// @description Handle death
function die() {
	state = EntityState.Dead;
	instance_destroy();
}