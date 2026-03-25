var _start_x = display_get_gui_width() - 20;
var _start_y = 20;
var _line = 20;

draw_set_halign(fa_right);

var _line_wave = $"Wave {wave}";
if ((phase == "spawning" || phase == "combat") && is_boss_wave) {
	_line_wave += "  — BOSS";
} else if (phase == "inter_wave" && inter_wave_timer > 0 && (wave mod boss_every == 0)) {
	_line_wave += "  — BOSS NEXT";
}

draw_text(_start_x, _start_y, _line_wave);
_start_y += _line;
draw_text(_start_x, _start_y, $"Enemies: {instance_number(parSnowman)}");
_start_y += _line;

if (phase == "inter_wave" && inter_wave_timer > 0) {
	draw_text(_start_x, _start_y, $"Next wave in: {ceil(inter_wave_timer / SECOND)}");
}

draw_set_halign(fa_left);
