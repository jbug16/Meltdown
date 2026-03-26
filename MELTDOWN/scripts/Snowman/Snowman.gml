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
	
	// When very close to player (within stop distance), stop moving to prevent spinning
	// stop_distance is set to attack_range, so enemies can reach attack range
	if (dist <= stop_distance) {
		target_hsp = 0;
		target_vsp = 0;
		return;
	}
	
	// When approaching attack range, slow down to prevent overshooting
	var approach_range = attack_range + 15;
	if (dist <= approach_range) {
		// Reduce movement speed when approaching to prevent overshooting
		var approach_speed = move_speed * 0.6;
		var dir = point_direction(x, y, target.x, target.y);
		target_hsp = lengthdir_x(approach_speed, dir);
		target_vsp = lengthdir_y(approach_speed, dir);
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
		
		// When stopped, still face the player if target exists
		if (instance_exists(target) && target.state == EntityState.Alive) {
			image_angle = point_direction(x, y, target.x, target.y);
		} else if (hsp != 0 || vsp != 0) {
			// If still moving from momentum, face movement direction
			image_angle = point_direction(0, 0, hsp, vsp);
		}
	}
	
	// Apply movement
	x += hsp;
	y += vsp;
	
	// Keep in room bounds 
	x = clamp(x, collision_radius, room_width - collision_radius);
	y = clamp(y, collision_radius, room_height - collision_radius);
}

/// @description Separate from nearby enemies and player to prevent overlapping
function separate_from_enemies() {
	var separation_strength = 0.8;  // How strong the separation push is
	var separation_x = 0;
	var separation_y = 0;
	var total_push = 0;
	
	// Check all other enemies
	with (parSnowman) {
		if (id != other.id && state == EntityState.Alive) {
			var dist = point_distance(x, y, other.x, other.y);
			var min_dist = collision_radius + other.collision_radius;
			
			// If too close, push away
			if (dist < min_dist && dist > 0) {
				var dir = point_direction(x, y, other.x, other.y);
				var push_strength = (min_dist - dist) / min_dist;  // Stronger push when closer
				separation_x += lengthdir_x(push_strength, dir);
				separation_y += lengthdir_y(push_strength, dir);
				total_push += push_strength;
			}
		}
	}
	
	// Check player collision (prevent enemies from going inside player)
	if (instance_exists(target) && target.state == EntityState.Alive) {
		var player_collision_radius = 32;  // Approximate player collision radius
		var dist = point_distance(x, y, target.x, target.y);
		var min_dist = collision_radius + player_collision_radius;
		
		// If too close to player, push away
		if (dist < min_dist && dist > 0) {
			var dir = point_direction(x, y, target.x, target.y);
			var push_strength = (min_dist - dist) / min_dist;  // Stronger push when closer
			separation_x += lengthdir_x(push_strength, dir);
			separation_y += lengthdir_y(push_strength, dir);
			total_push += push_strength;
		}
	}
	
	// Apply separation force
	if (total_push > 0) {
		separation_x *= separation_strength;
		separation_y *= separation_strength;
		
		// Apply separation
		x += separation_x;
		y += separation_y;
		
		// Keep in room bounds after separation
		x = clamp(x, collision_radius, room_width - collision_radius);
		y = clamp(y, collision_radius, room_height - collision_radius);
	}
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

/// @description Create frozen ground at current position (snapped to grid)
function create_frozen_ground() {
	// Calculate grid cell coordinates
	var grid_cell_x = floor(x / ICE_GRID_SIZE);
	var grid_cell_y = floor(y / ICE_GRID_SIZE);
	
	// Snap position to center of grid cell
	var grid_x = grid_cell_x * ICE_GRID_SIZE + (ICE_GRID_SIZE / 2);
	var grid_y = grid_cell_y * ICE_GRID_SIZE + (ICE_GRID_SIZE / 2);
	
	// Check if ice already exists at this grid position
	var existing_ice = noone;
	with (oIce) {
		var ice_grid_x = floor(x / ICE_GRID_SIZE);
		var ice_grid_y = floor(y / ICE_GRID_SIZE);
		if (ice_grid_x == grid_cell_x && ice_grid_y == grid_cell_y) {
			existing_ice = id;
			break;
		}
	}
	
	// If ice already exists at this grid cell, don't create
	if (existing_ice != noone) {
		return;
	}
	
	// Create ice patch at snapped grid position
	var ice = instance_create_layer(grid_x, grid_y, "Ice", oIce);
	ice.duration = freeze_duration;
	ice.radius = freeze_radius;
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

// ---------------------------------------------------------------------------
// Boss (Krampus) — reusable helpers; call from oBoss events (caller = self)
// ---------------------------------------------------------------------------

/// @description Apply duration/radius to oIce after instance_create (Create already ran)
/// @param {instance} ice_inst
/// @param {real} duration_sec
/// @param {real} radius_px
function snowman_configure_ice_instance(ice_inst, duration_sec, radius_px) {
	if (!instance_exists(ice_inst)) return;
	with (ice_inst) {
		duration = duration_sec;
		radius = radius_px;
		initial_duration = duration_sec;
		lifetime = duration_sec * SECOND;
		var _sprite_size = 64;
		image_xscale = (radius * 2) / _sprite_size;
		image_yscale = (radius * 2) / _sprite_size;
	}
}

/// @description Current wave from oWaveManager (1 if absent)
/// @return {real}
function snowman_get_wave_index() {
	var _wm = instance_find(oWaveManager, 0);
	if (_wm == noone) return 1;
	return _wm.wave;
}

/// @description Random snowman type for a wave — same weights as oWaveManager regular spawns
/// @param {real} wave_index
/// @return {asset.GMObject}
function snowman_pick_wave_enemy_object(wave_index) {
	var _t = min(1, (wave_index - 1) / 18);
	var _r = random(1);
	var _o_en = oTankSnowman;
	if (_r < lerp(0.55, 0.28, _t)) {
		_o_en = oFastSnowman;
	} else if (_r < lerp(0.55, 0.28, _t) + lerp(0.30, 0.32, _t)) {
		_o_en = oSpecialSnowman;
	}
	return _o_en;
}

/// @description Boss: circular slam of grid-snapped ice (same cell layout as create_frozen_ground; stacks on existing ice)
/// @param {real} radius_px
/// @param {real} duration_sec
function snowman_boss_freeze_slam(radius_px, duration_sec) {
	var _cell_half = ICE_GRID_SIZE * 0.5;
	var _cx = x;
	var _cy = y;
	var _min_ix = floor((_cx - radius_px) / ICE_GRID_SIZE);
	var _max_ix = floor((_cx + radius_px) / ICE_GRID_SIZE);
	var _min_iy = floor((_cy - radius_px) / ICE_GRID_SIZE);
	var _max_iy = floor((_cy + radius_px) / ICE_GRID_SIZE);
	for (var _ix = _min_ix; _ix <= _max_ix; _ix++) {
		for (var _iy = _min_iy; _iy <= _max_iy; _iy++) {
			var _gx = _ix * ICE_GRID_SIZE + _cell_half;
			var _gy = _iy * ICE_GRID_SIZE + _cell_half;
			if (point_distance(_cx, _cy, _gx, _gy) > radius_px) {
				continue;
			}
			var _ice = instance_create_layer(_gx, _gy, "Ice", oIce);
			if (_ice != noone) {
				snowman_configure_ice_instance(_ice, duration_sec, _cell_half);
			}
		}
	}
}

/// @description Boss: even ring of ice shots (oIceProjectile) from caller
/// @param {real} proj_count
/// @param {real} move_speed
/// @param {real} damage_each
function snowman_boss_ice_projectile_spread(proj_count, move_speed, damage_each) {
	var _base = random(360);
	for (var _i = 0; _i < proj_count; _i++) {
		var _dir = _base + (_i * 360 / proj_count);
		var _p = instance_create_layer(x, y, "Items", oIceProjectile);
		if (_p != noone) {
			_p.direction = _dir;
			_p.speed = move_speed;
			_p.damage = damage_each;
			_p.image_angle = _dir;
		}
	}
}

/// @description Boss: spawn one minion at map edge with same scaling as oWaveManager
/// @param {asset.GMObject} enemy_object
/// @return {instance}
function snowman_boss_summon_at_edge(enemy_object) {
	var _wm = instance_find(oWaveManager, 0);
	var _wave_n = snowman_get_wave_index();
	var _hp_b = 1 + (_wave_n - 1) * 0.08;
	var _spd_b = 1 + (_wave_n - 1) * 0.03;
	var _dmg_b = 1 + (_wave_n - 1) * 0.07;
	var _rm = 80;
	var _layer_name = "Enemies";
	if (_wm != noone) {
		_rm = _wm.room_margin;
		_layer_name = _wm.enemy_layer_name;
	}
	var _side = irandom(3);
	var _sx, _sy;
	switch (_side) {
		case 0:
			_sx = -_rm;
			_sy = random(room_height);
			break;
		case 1:
			_sx = room_width + _rm;
			_sy = random(room_height);
			break;
		case 2:
			_sx = random(room_width);
			_sy = -_rm;
			break;
		default:
			_sx = random(room_width);
			_sy = room_height + _rm;
			break;
	}
	var _inst = instance_create_layer(_sx, _sy, _layer_name, enemy_object);
	if (_inst != noone) {
		var _hm = _hp_b;
		var _sm = _spd_b;
		var _dm = _dmg_b;
		with (_inst) {
			max_hp = max(1, ceil(max_hp * _hm));
			hp = max_hp;
			move_speed *= _sm;
			attack_damage = max(1, ceil(attack_damage * _dm));
		}
	}
	return _inst;
}

/// @description Boss: hold distance between min/max from target; strafe in the band
/// @param {real} dist_min
/// @param {real} dist_max
function snowman_boss_update_ring_movement(dist_min, dist_max) {
	if (target == noone) {
		target_hsp = 0;
		target_vsp = 0;
		return;
	}
	var _dist = point_distance(x, y, target.x, target.y);
	var _dir = point_direction(x, y, target.x, target.y);
	if (_dist > dist_max) {
		target_hsp = lengthdir_x(move_speed, _dir);
		target_vsp = lengthdir_y(move_speed, _dir);
	} else if (_dist < dist_min) {
		target_hsp = lengthdir_x(-move_speed, _dir);
		target_vsp = lengthdir_y(-move_speed, _dir);
	} else {
		var _strafe = _dir + 90;
		target_hsp = lengthdir_x(move_speed * 0.85, _strafe);
		target_vsp = lengthdir_y(move_speed * 0.85, _strafe);
	}
}