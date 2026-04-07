// --- Health + heat (HUD) ---
if (instance_exists(oPlayer) && !game_over) {
	var _gw = display_get_gui_width();
	var _bar_w = min(240, _gw - 32);
	var _bar_h = 14;
	var _pad = 16;
	var _x1 = _pad;
	var _x2 = _pad + _bar_w;
	var _line_h = string_height("M");
	var _gap = 10;

	var _hp_y_label = _pad;
	var _hp_y1 = _hp_y_label + _line_h + 4;
	var _heat_y_label = _hp_y1 + _bar_h + _gap + 4;
	var _heat_y1 = _heat_y_label + _line_h + 4;

	// --- HP ---
	var _hp_ratio = oPlayer.max_hp > 0 ? clamp(oPlayer.hp / oPlayer.max_hp, 0, 1) : 0;
	var _col_hp_low = make_color_rgb(220, 64, 64);
	var _col_hp_high = make_color_rgb(96, 212, 132);
	var _fill_hp = merge_color(_col_hp_low, _col_hp_high, _hp_ratio);

	draw_set_color(c_black);
	draw_rectangle(_x1 - 2, _hp_y_label - 2, _x2 + 2, _hp_y1 + _bar_h + 2, false);
	draw_set_color(make_color_rgb(28, 28, 34));
	draw_rectangle(_x1, _hp_y_label, _x2, _hp_y1 + _bar_h, false);
	draw_set_color(make_color_rgb(36, 36, 42));
	draw_rectangle(_x1, _hp_y1, _x2, _hp_y1 + _bar_h, false);
	if (_hp_ratio > 0) {
		draw_set_color(_fill_hp);
		draw_rectangle(_x1, _hp_y1, _x1 + _bar_w * _hp_ratio, _hp_y1 + _bar_h, false);
	}
	draw_set_color(_hp_ratio <= 0.15 ? merge_color(c_white, _col_hp_low, 0.4) : c_white);
	draw_rectangle(_x1, _hp_y1, _x2, _hp_y1 + _bar_h, true);

	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	draw_set_color(make_color_rgb(200, 204, 214));
	draw_text(_x1 + 4, _hp_y_label + 2, "HP");
	draw_set_halign(fa_right);
	draw_set_color(make_color_rgb(160, 168, 180));
	draw_text(_x2 - 4, _hp_y_label + 2, $"{ceil(oPlayer.hp)} / {ceil(oPlayer.max_hp)}");
	draw_set_halign(fa_left);

	// --- Heat ---
	var _ratio = oPlayer.max_heat > 0 ? clamp(oPlayer.heat / oPlayer.max_heat, 0, 1) : 0;
	var _col_cold = make_color_rgb(72, 148, 210);
	var _col_warm = make_color_rgb(255, 118, 42);
	var _fill = merge_color(_col_cold, _col_warm, _ratio);

	draw_set_color(c_black);
	draw_rectangle(_x1 - 2, _heat_y_label - 2, _x2 + 2, _heat_y1 + _bar_h + 2, false);
	draw_set_color(make_color_rgb(28, 28, 34));
	draw_rectangle(_x1, _heat_y_label, _x2, _heat_y1 + _bar_h, false);
	draw_set_color(make_color_rgb(36, 36, 42));
	draw_rectangle(_x1, _heat_y1, _x2, _heat_y1 + _bar_h, false);
	if (_ratio > 0) {
		draw_set_color(_fill);
		draw_rectangle(_x1, _heat_y1, _x1 + _bar_w * _ratio, _heat_y1 + _bar_h, false);
	}
	draw_set_color(_ratio <= 0.08 ? merge_color(c_white, _col_cold, 0.4) : c_white);
	draw_rectangle(_x1, _heat_y1, _x2, _heat_y1 + _bar_h, true);

	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	draw_set_color(make_color_rgb(200, 204, 214));
	draw_text(_x1 + 4, _heat_y_label + 2, "HEAT");
	draw_set_halign(fa_right);
	draw_set_color(make_color_rgb(160, 168, 180));
	draw_text(_x2 - 4, _heat_y_label + 2, $"{ceil(oPlayer.heat)} / {ceil(oPlayer.max_heat)}");
	draw_set_halign(fa_left);
}

if (game_over) {
	var _gw = display_get_gui_width();
	var _gh = display_get_gui_height();
	var _bg = make_color_rgb(18, 20, 28);
	var _text_dim = make_color_rgb(160, 168, 180);

	draw_set_alpha(1);
	draw_set_color(_bg);
	draw_rectangle(0, 0, _gw, _gh, false);

	var _logo_scale = 2;
	var _lw = sprite_get_width(sLogo) * _logo_scale;
	var _lh = sprite_get_height(sLogo) * _logo_scale;
	var _cx = _gw * 0.5;
	var _logo_y = _gh * 0.22;
	draw_sprite_ext(sLogo, 0, _cx - _lw * 0.5, _logo_y - _lh * 0.5, _logo_scale, _logo_scale, 0, c_white, 1);

	var _title_y = _logo_y + _lh * 0.5 + 48;
	draw_set_halign(fa_center);
	draw_set_valign(fa_top);
	draw_set_color(_text_dim);
	draw_text(_cx, _title_y, "THE COLD WON THIS TIME");

	var _menu_y = _title_y + 72;
	gui_menu_draw_option(_cx, _menu_y, "GAME OVER", true);

	gui_menu_draw_hint(_cx, _gh, "R TO RETRY   M FOR MAIN MENU");

	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	draw_set_color(c_white);
	exit;
}
