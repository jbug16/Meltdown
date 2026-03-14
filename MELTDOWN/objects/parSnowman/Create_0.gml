// State system
state = EntityState.Alive;

// Health system
max_hp = 50; 
hp = max_hp;
health_percentage = 1.0;  // For visual feedback (melting effect)

// Movement
move_speed = 2.0;
accel = 0.3;
decel = 0.25;
hsp = 0;
vsp = 0;
target_hsp = 0;
target_vsp = 0;

// Pathfinding
pathfinding_update_rate = 0.1;  // Update path every X seconds
pathfinding_timer = 0;
pathfinding_active = true;
pathfinding_range = 2000;  // Max distance to pathfind to player

// Attack system
attack_range = 80; 
attack_damage = 10; 
attack_cooldown = 1.5; 
attack_timer = 0;
can_attack = true;

// Stop distance - enemies stop moving when this close to player (prevents spinning)
// Set to attack_range so enemies can reach attack range but stop to prevent spinning
stop_distance = attack_range;

// Visual
image_angle = 0;
sprite_scale = 1.0;  // For melting effect
base_sprite_scale = 1.0;

// Hit feedback
hit_flash_timer = 0;
hit_flash_duration = 0.2;  // How long flash lasts (seconds)
hit_knockback_timer = 0;
hit_knockback_duration = 0.15;  // How long knockback lasts (seconds)
hit_knockback_strength = 8.0;  // Knockback force
hit_knockback_x = 0;
hit_knockback_y = 0;

// Target (player)
target = noone;
find_target();

// Freeze system
freeze_ground = true;  // Whether this enemy type freezes ground
freeze_radius = 32;  // Radius of frozen ground patches
freeze_update_rate = 0.2;  // How often to create frozen ground (seconds)
freeze_timer = 0;  // Timer for creating frozen ground
freeze_duration = 30;  // How long frozen ground lasts (seconds) - longer when no enemies nearby

// Collision
collision_radius = 128; 