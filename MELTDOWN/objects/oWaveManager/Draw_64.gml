var _gw = display_get_gui_width();

// Boss HP bar (top center)
var _boss = instance_find(oBoss, 0);
if (_boss != noone && instance_exists(_boss) && _boss.state == EntityState.Alive) {
	var _bar_w = _gw * 0.42;
	var _bar_h = 14;
	var _cx = _gw * 0.5;
	var _y = 18;
	var _pct = clamp(_boss.hp / max(1, _boss.max_hp), 0, 1);
	var _x1 = _cx - _bar_w * 0.5;
	var _x2 = _cx + _bar_w * 0.5;
	draw_set_color(c_black);
	draw_rectangle(_x1 - 2, _y - 2, _x2 + 2, _y + _bar_h + 2, false);
	draw_set_color(make_color_rgb(36, 36, 42));
	draw_rectangle(_x1, _y, _x2, _y + _bar_h, false);
	draw_set_color(make_color_rgb(200, 48, 48));
	draw_rectangle(_x1, _y, _x1 + _bar_w * _pct, _y + _bar_h, false);
	draw_set_color(c_white);
}

var _start_x = _gw - 20;
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
