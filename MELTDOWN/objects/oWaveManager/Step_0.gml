switch (phase) {
	case "inter_wave":
		if (inter_wave_timer > 0) {
			inter_wave_timer -= 1;
		}
		if (inter_wave_timer <= 0) {
			is_boss_wave = (wave mod boss_every == 0);
			spawn_queue = [];
			
			if (is_boss_wave) {
				var w_hp = (1 + (wave - 1) * 0.12) * 2.5;
				var w_spd = (1 + (wave - 1) * 0.04) * 1.15;
				var w_dmg = (1 + (wave - 1) * 0.10) * 1.35;
				array_push(spawn_queue, { enemy: oTankSnowman, hp_m: w_hp, spd_m: w_spd, dmg_m: w_dmg });
			} else {
				var n = min(max_enemy_count, base_enemy_count + (wave - 1) * count_per_wave);
				var hp_b = 1 + (wave - 1) * 0.08;
				var spd_b = 1 + (wave - 1) * 0.03;
				var dmg_b = 1 + (wave - 1) * 0.07;
				var t = min(1, (wave - 1) / 18);
				for (var i = 0; i < n; i++) {
					var r = random(1);
					var o_en = oTankSnowman;
					if (r < lerp(0.55, 0.28, t)) {
						o_en = oFastSnowman;
					} else if (r < lerp(0.55, 0.28, t) + lerp(0.30, 0.32, t)) {
						o_en = oSpecialSnowman;
					}
					array_push(spawn_queue, { enemy: o_en, hp_m: hp_b, spd_m: spd_b, dmg_m: dmg_b });
				}
			}
			spawn_idx = 0;
			spawn_timer = 0;
			phase = "spawning";
		}
		break;
		
	case "spawning":
		if (spawn_timer > 0) {
			spawn_timer -= 1;
		}
		if (spawn_timer <= 0 && spawn_idx < array_length(spawn_queue)) {
			var entry = spawn_queue[spawn_idx];
			var side = irandom(3);
			var sx, sy;
			switch (side) {
				case 0:
					sx = -room_margin;
					sy = random(room_height);
					break;
				case 1:
					sx = room_width + room_margin;
					sy = random(room_height);
					break;
				case 2:
					sx = random(room_width);
					sy = -room_margin;
					break;
				default:
					sx = random(room_width);
					sy = room_height + room_margin;
					break;
			}
			var inst = instance_create_layer(sx, sy, enemy_layer_name, entry.enemy);
			if (inst != noone) {
				var hm = entry.hp_m;
				var sm = entry.spd_m;
				var dm = entry.dmg_m;
				with (inst) {
					max_hp = max(1, ceil(max_hp * hm));
					hp = max_hp;
					move_speed *= sm;
					attack_damage = max(1, ceil(attack_damage * dm));
				}
			}
			spawn_idx += 1;
			spawn_timer = spawn_interval_frames;
		}
		if (spawn_idx >= array_length(spawn_queue)) {
			spawn_queue = [];
			phase = "combat";
		}
		break;
		
	case "combat":
		if (instance_number(parSnowman) <= 0) {
			wave += 1;
			inter_wave_timer = base_inter_wave_delay + max(0, wave - 2) * inter_wave_delay_ramp;
			phase = "inter_wave";
		}
		break;
}
