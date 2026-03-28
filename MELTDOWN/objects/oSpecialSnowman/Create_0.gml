// Inherit the parent event
event_inherited();

// Less HP
max_hp = 15;
hp = max_hp;

// Movement - Slow base speed, but will burst faster
move_speed = 1.0;  // Slow unnatural movement
accel = 0.2;  // Slower acceleration for unnatural feel

// Creeper behavior state
creeper_state = "pause";  // "pause" or "burst"
pause_duration = 1.5;  // How long to pause (seconds)
burst_duration = 0.8;  // How long to burst (seconds)
creeper_timer = pause_duration;  // Start with a pause

// Burst movement speed (much faster than base)
burst_speed = 7.0;
