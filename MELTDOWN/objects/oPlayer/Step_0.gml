// Ignore if dead
if (state == EntityState.Dead) exit;

// Input
var h_input = (keyboard_check(vk_right) || keyboard_check(ord("D"))) - (keyboard_check(vk_left) || keyboard_check(ord("A")));
var v_input = (keyboard_check(vk_down) || keyboard_check(ord("S"))) - (keyboard_check(vk_up) || keyboard_check(ord("W")));

// Check if standing on frozen ground
var on_ice = false;
var ice_check = instance_place(x, y, oIce);
if (ice_check != noone) {
	on_ice = true;
}

// Ice makes movement slower and more slippery
var current_move_speed = on_ice ? move_speed * 0.75 : move_speed;  // slower on ice
var current_decel = on_ice ? 0.05 : decel;  // Much lower deceleration (more sliding)
var current_accel = on_ice ? 0.25 : accel;  // Reduced acceleration (harder to change direction)

// Movement
var target_hsp = 0;
var target_vsp = 0;
if (h_input != 0 || v_input != 0) {
	var len = sqrt(h_input * h_input + v_input * v_input);
	target_hsp = (h_input / len) * current_move_speed;
	target_vsp = (v_input / len) * current_move_speed;
}

if (h_input != 0 || v_input != 0) {
	hsp = lerp(hsp, target_hsp, current_accel);
	vsp = lerp(vsp, target_vsp, current_accel);
	image_angle = point_direction(0, 0, hsp, vsp);
} else {
	hsp = lerp(hsp, 0, current_decel);
	vsp = lerp(vsp, 0, current_decel);
}

x += hsp;
y += vsp;

// Heat drain (passive)
heat -= heat_drain_per_sec / SECOND;
heat = clamp(heat, 0, max_heat);

// Freezing at 0 heat
if (heat <= 0) {
	player_damage(freeze_damage_per_sec / SECOND);
}