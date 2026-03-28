switch (phase) {
	case "inter_wave":
		if (inter_wave_timer > 0) {
			inter_wave_timer -= 1;
		}
		if (inter_wave_timer <= 0) {
			var _gm = instance_find(oGameManager, 0);
			var _lvl = (_gm != noone) ? _gm.current_level : 1;
			var _d = (_lvl - 1) * waves_per_level + wave;
			
			is_boss_wave = (wave == waves_per_level);
			spawn_queue = [];
			
			if (is_boss_wave) {
				var w_hp = (1 + (_d - 1) * 0.12) * 2.5;
				var w_spd = (1 + (_d - 1) * 0.04) * 1.15;
				var w_dmg = (1 + (_d - 1) * 0.10) * 1.35;
				array_push(spawn_queue, { enemy: oBoss, hp_m: w_hp, spd_m: w_spd, dmg_m: w_dmg });
			} else {
				var n = snowman_regular_wave_enemy_count(_d, max_enemy_count);
				var hp_b = 1 + (_d - 1) * 0.08;
				var spd_b = 1 + (_d - 1) * 0.03;
				var dmg_b = 1 + (_d - 1) * 0.07;
				for (var i = 0; i < n; i++) {
					var o_en = snowman_pick_wave_enemy_object(_d);
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
		if (instance_number(parSnowman) > 0) {
			break;
		}
		
		var _g = instance_find(oGameManager, 0);
		
		// Arena 3, wave 5: after mini-boss, spawn placeholder final boss (same object)
		if (wave == waves_per_level && _g != noone && _g.current_level == 3 && !_g.final_boss_spawned) {
			_g.final_boss_spawned = true;
			var _d_final = (_g.current_level - 1) * waves_per_level + wave + 1;
			var wf_hp = (1 + (_d_final - 1) * 0.12) * 2.5 * 1.2;
			var wf_spd = (1 + (_d_final - 1) * 0.04) * 1.15 * 1.08;
			var wf_dmg = (1 + (_d_final - 1) * 0.10) * 1.35 * 1.12;
			spawn_queue = [];
			array_push(spawn_queue, { enemy: oBoss, hp_m: wf_hp, spd_m: wf_spd, dmg_m: wf_dmg });
			spawn_idx = 0;
			spawn_timer = 0;
			phase = "spawning";
			break;
		}
		
		// End of level 1 or 2: go to next arena (wave resets in new room)
		if (wave == waves_per_level && _g != noone && _g.current_level < 3) {
			if (_g.current_level == 1) {
				_g.current_level = 2;
				room_goto(rArena2);
			} else if (_g.current_level == 2) {
				_g.current_level = 3;
				room_goto(rArena3);
			}
			break;
		}
		
		// Final boss down — run complete
		if (wave == waves_per_level && _g != noone && _g.current_level == 3 && _g.final_boss_spawned) {
			phase = "victory";
			break;
		}
		
		wave += 1;
		inter_wave_timer = base_inter_wave_delay + max(0, wave - 2) * inter_wave_delay_ramp;
		phase = "inter_wave";
		break;
		
	case "victory":
		break;
}
