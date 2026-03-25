enemy_layer_name = "Enemies";
boss_every = 2;

base_inter_wave_delay = SECOND * 3;
inter_wave_delay_ramp = SECOND / 6;

base_enemy_count = 4;
count_per_wave = 2;
max_enemy_count = 36;

spawn_interval_frames = max(1, SECOND / 4);
room_margin = 80;

wave = 1;
phase = "inter_wave";
inter_wave_timer = 0;

spawn_queue = [];
spawn_idx = 0;
spawn_timer = 0;
is_boss_wave = false;