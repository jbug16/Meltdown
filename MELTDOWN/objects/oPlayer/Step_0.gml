// Brotato-style top-down movement — step
if (state == EntityState.Dead) exit;

var h_input = (keyboard_check(vk_right) || keyboard_check(ord("D"))) - (keyboard_check(vk_left) || keyboard_check(ord("A")));
var v_input = (keyboard_check(vk_down) || keyboard_check(ord("S"))) - (keyboard_check(vk_up) || keyboard_check(ord("W")));

var target_hsp = 0;
var target_vsp = 0;
if (h_input != 0 || v_input != 0) {
	var len = sqrt(h_input * h_input + v_input * v_input);
	target_hsp = (h_input / len) * move_speed;
	target_vsp = (v_input / len) * move_speed;
}

if (h_input != 0 || v_input != 0) {
	hsp = lerp(hsp, target_hsp, accel);
	vsp = lerp(vsp, target_vsp, accel);
	image_angle = point_direction(0, 0, hsp, vsp);
} else {
	hsp = lerp(hsp, 0, decel);
	vsp = lerp(vsp, 0, decel);
}

x += hsp;
y += vsp;
