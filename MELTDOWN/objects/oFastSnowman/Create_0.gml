// Inherit the parent event
event_inherited();

// Faster movement, less health, smaller freeze patches, aggressive rushing

// Health - Less HP
max_hp = 20;
hp = max_hp;

// Movement - Much faster
move_speed = 3.5;
accel = 0.5;  // Faster acceleration for quick rushing

// Pathfinding - More frequent updates for responsive movement
pathfinding_update_rate = 0.05;

// Freeze system - Smaller patches
freeze_radius = 20;

