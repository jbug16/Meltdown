event_inherited();

// HUD (oWaveManager Draw GUI)
boss_ui_name = "KRAMPUS";

freeze_ground = false;
pathfinding_active = false;

// Higher base HP before oWaveManager multipliers
max_hp = 100;
hp = max_hp;

move_speed *= 0.55;

// Boss tuning (seconds for timers decremented with 1/SECOND)
boss_phase = 1;
boss_ring_min = 160;
boss_ring_max = 300;
boss_slam_radius_p1 = 128;
boss_slam_radius_p2 = 192;
boss_summon_interval_p1 = 4;
boss_summon_interval_p2 = 2.5;
boss_attack_interval_p1 = 2.5;
boss_attack_interval_p2 = 1.35;
boss_summon_timer = 2;
boss_attack_timer = 1.25;
boss_attack_is_slam = true;
boss_phase2_speed_mult = 1.32;