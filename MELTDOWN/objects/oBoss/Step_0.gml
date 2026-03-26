// Krampus — does not inherit parSnowman Step (no melee chase / passive ice trail)
if (state == EntityState.Dead) exit;

if (!instance_exists(target) || target.state == EntityState.Dead) {
	find_target();
}

if (target == noone) {
	hsp = lerp(hsp, 0, decel);
	vsp = lerp(vsp, 0, decel);
	x += hsp;
	y += vsp;
	x = clamp(x, collision_radius, room_width - collision_radius);
	y = clamp(y, collision_radius, room_height - collision_radius);
	update_visuals();
	exit;
}

// Phase 2 at 50% HP
if (boss_phase == 1 && hp <= max_hp * 0.5) {
	boss_phase = 2;
	move_speed *= boss_phase2_speed_mult;
}

// Knockback from hits (same feel as other snowmen)
if (hit_knockback_timer > 0) {
	x += hit_knockback_x;
	y += hit_knockback_y;
	hit_knockback_x *= 0.75;
	hit_knockback_y *= 0.75;
	hit_knockback_timer -= 1 / SECOND;
	if (hit_knockback_timer <= 0) {
		hit_knockback_x = 0;
		hit_knockback_y = 0;
	}
}

snowman_boss_update_ring_movement(boss_ring_min, boss_ring_max);
update_movement();
separate_from_enemies();

// Summon minions
boss_summon_timer -= 1 / SECOND;
if (boss_summon_timer <= 0) {
	snowman_boss_summon_at_edge(snowman_pick_wave_enemy_object(snowman_get_wave_index()));
	boss_summon_timer = boss_phase == 1 ? boss_summon_interval_p1 : boss_summon_interval_p2;
}

// Alternate slam / ice spread
boss_attack_timer -= 1 / SECOND;
if (boss_attack_timer <= 0) {
	if (boss_attack_is_slam) {
		var _r = boss_phase == 1 ? boss_slam_radius_p1 : boss_slam_radius_p2;
		var _d = boss_phase == 1 ? 22 : 30;
		snowman_boss_freeze_slam(_r, _d);
	} else {
		var _n = boss_phase == 1 ? 8 : 12;
		var _spd = boss_phase == 1 ? 5 : 6.5;
		var _dmg = boss_phase == 1 ? 8 : 12;
		snowman_boss_ice_projectile_spread(_n, _spd, _dmg);
	}
	boss_attack_is_slam = !boss_attack_is_slam;
	boss_attack_timer = boss_phase == 1 ? boss_attack_interval_p1 : boss_attack_interval_p2;
}

update_visuals();
