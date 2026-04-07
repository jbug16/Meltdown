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
var _title_scale = 1.85;

draw_set_halign(fa_center);
draw_set_valign(fa_top);

draw_set_color(c_black);
draw_text_transformed(_cx + 2, _title_y + 2, "MELTDOWN", _title_scale, _title_scale, 0);
draw_set_color(make_color_rgb(240, 244, 252));
draw_text_transformed(_cx, _title_y, "MELTDOWN", _title_scale, _title_scale, 0);

var _subtitle_y = _title_y + string_height("MELTDOWN") * _title_scale + 16;
draw_set_color(_text_dim);
draw_text(_cx, _subtitle_y, "SURVIVE THE COLD");

var _line_h = gui_menu_line_height();
var _menu_y = _subtitle_y + string_height("M") + 48;

for (var i = 0; i < menu_count; i++) {
	gui_menu_draw_option(_cx, _menu_y + i * _line_h, menu_options[i], i == menu_selection);
}

gui_menu_draw_hint(_cx, _gh, "UP / DOWN   ENTER TO SELECT   ESC TO QUIT");

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
