var _gw = display_get_gui_width();

// Boss health bar (top center)
var _boss = instance_find(oBoss, 0);
if (_boss != noone && instance_exists(_boss) && _boss.state == EntityState.Alive) {
	var _name = variable_instance_exists(_boss, "boss_ui_name") ? _boss.boss_ui_name : "BOSS";
	var _bar_w = min(_gw * 0.42, _gw - 260);
	var _bar_h = 18;
	var _cx = _gw * 0.5;
	var _pct = clamp(_boss.hp / max(1, _boss.max_hp), 0, 1);
	var _p2 = variable_instance_exists(_boss, "boss_phase") && _boss.boss_phase >= 2;
	var _fill = _p2 ? make_color_rgb(255, 92, 36) : make_color_rgb(200, 48, 48);
	
	draw_set_halign(fa_center);
	draw_set_valign(fa_top);
	draw_set_color(c_black);
	draw_text(_cx + 1, 11, _name);
	draw_set_color(c_white);
	draw_text(_cx, 10, _name);
	
	var _bar_top = 10 + string_height(_name) + 6;
	if (_p2) {
		draw_set_color(c_black);
		draw_text_transformed(_cx + 1, _bar_top + 1, "ENRAGED", 0.72, 0.72, 0);
		draw_set_color(make_color_rgb(255, 140, 88));
		draw_text_transformed(_cx, _bar_top, "ENRAGED", 0.72, 0.72, 0);
		_bar_top += string_height("M") * 0.72 + 4;
	}
	
	var _x1 = _cx - _bar_w * 0.5;
	var _x2 = _cx + _bar_w * 0.5;
	var _y1 = _bar_top;
	var _y2 = _bar_top + _bar_h;
	draw_set_color(c_black);
	draw_rectangle(_x1 - 2, _y1 - 2, _x2 + 2, _y2 + 2, false);
	draw_set_color(make_color_rgb(22, 22, 28));
	draw_rectangle(_x1, _y1, _x2, _y2, false);
	draw_set_color(make_color_rgb(48, 48, 58));
	draw_rectangle(_x1 + 1, _y1 + 1, _x2 - 1, _y2 - 1, true);
	draw_set_color(_fill);
	draw_rectangle(_x1, _y1, _x1 + _bar_w * _pct, _y2, false);
	draw_set_color(make_color_rgb(255, 255, 255));
	draw_set_alpha(0.14);
	draw_rectangle(_x1, _y1, _x2, _y1 + max(2, _bar_h * 0.35), false);
	draw_set_alpha(1);
	
	var _hp_y = _y2 + 6;
	draw_set_color(c_black);
	draw_text(_cx + 1, _hp_y + 1, $"{ceil(_boss.hp)} / {ceil(_boss.max_hp)}");
	draw_set_color(make_color_rgb(190, 194, 208));
	draw_text(_cx, _hp_y, $"{ceil(_boss.hp)} / {ceil(_boss.max_hp)}");
	
	draw_set_halign(fa_left);
	draw_set_color(c_white);
}

// --- Wave counter panel (top right) ---
var _gm_draw = instance_find(oGameManager, 0);
var _lv = (_gm_draw != noone) ? _gm_draw.current_level : 1;

var _pad = 10;
var _panel_w = 196;
var _panel_x = _gw - 20 - _panel_w;
var _panel_y = 20;
var _inner_x1 = _panel_x + _pad;
var _inner_x2 = _panel_x + _panel_w - _pad;

// Measure dynamic footer height
var _footer_lines = 1;
if (phase == "inter_wave" && inter_wave_timer > 0) _footer_lines += 1;
var _line_h = string_height("M");
var _header_h = _line_h + 4;
// BOSS / BOSS NEXT sit in their own strip between the wave fraction and the pips (not at the bottom of the wave block, which overlapped the dots).
var _show_boss_status = (phase != "victory" && ((phase == "spawning" || phase == "combat") && is_boss_wave
	|| (phase == "inter_wave" && inter_wave_timer > 0 && (wave == waves_per_level))));
var _boss_status_h = _show_boss_status ? (2 + _line_h + 4) : 0;
// Victory uses two lines (RUN + COMPLETE); normal play is only the scaled "n / m" (no WAVE label).
var _wave_num_h = (phase == "victory")
	? (_line_h * 2 + round(_line_h * 0.35) + 4)
	: (round(_line_h * 1.35) + 8);
var _pip_row_h = 18;
var _footer_h = _footer_lines * _line_h + 4;
var _panel_h = _pad + _header_h + _wave_num_h + _boss_status_h + _pip_row_h + _footer_h + _pad;

draw_set_color(c_black);
draw_rectangle(_panel_x - 2, _panel_y - 2, _panel_x + _panel_w + 2, _panel_y + _panel_h + 2, false);
draw_set_color(make_color_rgb(28, 28, 34));
draw_rectangle(_panel_x, _panel_y, _panel_x + _panel_w, _panel_y + _panel_h, false);
draw_set_color(make_color_rgb(52, 52, 62));
draw_rectangle(_inner_x1, _panel_y + _pad, _inner_x2, _panel_y + _pad + _header_h - 2, false);

draw_set_halign(fa_right);
draw_set_valign(fa_top);
draw_set_color(make_color_rgb(180, 186, 198));
draw_text(_inner_x2, _panel_y + _pad + 2, $"LEVEL {_lv}");

var _wave_main = $"{wave} / {waves_per_level}";
var _status = "";
var _victory_sub = "";
if (phase == "victory") {
	_wave_main = "COMPLETE";
	_victory_sub = "RUN";
} else if ((phase == "spawning" || phase == "combat") && is_boss_wave) {
	_status = "BOSS";
} else if (phase == "inter_wave" && inter_wave_timer > 0 && wave == waves_per_level) {
	_status = "BOSS NEXT";
}

var _wave_block_y = _panel_y + _pad + _header_h + 2;
if (_victory_sub != "") {
	draw_set_color(make_color_rgb(200, 204, 214));
	draw_text(_inner_x2, _wave_block_y, _victory_sub);
	_wave_block_y += _line_h * 0.35;
}
draw_set_color(c_white);
draw_text_transformed(_inner_x2, _wave_block_y, _wave_main, 1.35, 1.35, 0);

if (_status != "") {
	draw_set_color(make_color_rgb(255, 196, 96));
	draw_text(_inner_x2, _panel_y + _pad + _header_h + _wave_num_h + 2, _status);
}

// Progress pips (waves within this level)
var _pip_y = _panel_y + _pad + _header_h + _wave_num_h + _boss_status_h + 2;
var _pip_spacing = 28;
var _pip_total_w = (waves_per_level - 1) * _pip_spacing;
var _pip_start_x = _inner_x2 - _pip_total_w;
for (var _p = 1; _p <= waves_per_level; _p++) {
	var _px = _pip_start_x + (_p - 1) * _pip_spacing;
	var _py = _pip_y + 6;
	var _r = 5;
	var _boss_pip = (_p == waves_per_level);
	
	if (phase == "victory") {
		draw_set_color(make_color_rgb(110, 200, 130));
		draw_circle(_px, _py, _r, false);
		continue;
	}
	
	var _done = (_p < wave);
	var _current = (_p == wave);
	
	if (_done) {
		draw_set_color(_boss_pip ? make_color_rgb(200, 72, 72) : make_color_rgb(96, 180, 120));
		draw_circle(_px, _py, _r, false);
	} else if (_current) {
		draw_set_color(c_black);
		draw_circle(_px, _py, _r + 1, false);
		draw_set_color(_boss_pip ? make_color_rgb(255, 120, 90) : make_color_rgb(120, 190, 255));
		draw_circle(_px, _py, _r, false);
	} else {
		draw_set_color(make_color_rgb(44, 44, 52));
		draw_circle(_px, _py, _r, false);
		draw_set_color(make_color_rgb(70, 72, 82));
		draw_circle(_px, _py, _r, true);
	}
}

var _foot_y = _panel_y + _panel_h - _pad - _footer_h;
draw_set_color(make_color_rgb(160, 164, 176));
draw_text(_inner_x2, _foot_y, $"Enemies: {instance_number(parSnowman)}");
if (phase == "inter_wave" && inter_wave_timer > 0) {
	draw_set_color(make_color_rgb(200, 200, 210));
	draw_text(_inner_x2, _foot_y + _line_h, $"Next in {ceil(inter_wave_timer / SECOND)}s");
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
