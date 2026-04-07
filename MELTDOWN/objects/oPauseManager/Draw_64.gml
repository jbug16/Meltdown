var _gw = display_get_gui_width();
var _gh = display_get_gui_height();

var _bg = make_color_rgb(18, 20, 28);
draw_set_alpha(1);
draw_set_color(_bg);
draw_rectangle(0, 0, _gw, _gh, false);

var _labels = ["RESUME", "RESTART RUN", "MAIN MENU", "QUIT"];
var _cx = _gw * 0.5;
var _title_y = _gh * 0.28;
var _title_scale = 1.85;

draw_set_halign(fa_center);
draw_set_valign(fa_top);

draw_set_color(c_black);
draw_text_transformed(_cx + 2, _title_y + 2, "PAUSED", _title_scale, _title_scale, 0);
draw_set_color(make_color_rgb(240, 244, 252));
draw_text_transformed(_cx, _title_y, "PAUSED", _title_scale, _title_scale, 0);

var _menu_y = _title_y + string_height("PAUSED") * _title_scale + 72;
var _line_h = gui_menu_line_height();

for (var _i = 0; _i < array_length(_labels); _i++) {
	gui_menu_draw_option(_cx, _menu_y + _i * _line_h, _labels[_i], _i == menu_index);
}

gui_menu_draw_hint(_cx, _gh, "UP / DOWN   ENTER TO SELECT   ESC TO RESUME");

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
