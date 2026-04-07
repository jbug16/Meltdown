/// @description True when the arena run is paused (Escape menu).
function game_is_paused() {
	var _gm = instance_find(oGameManager, 0);
	return (_gm != noone && _gm.pause);
}

/// @description New run from arena 1 (same as main menu Play). Prefer this over game_restart(), which reloads rInit and the Game Start event sends the player to the main menu.
function game_restart_run() {
	var _gm = instance_find(oGameManager, 0);
	if (_gm != noone) {
		with (_gm) {
			current_level = 1;
			final_boss_spawned = false;
			pause = false;
			game_over = false;
			game_over_menu_index = 0;
		}
	}
	if (instance_exists(oPauseManager)) {
		with (oPauseManager) instance_destroy();
	}
	room_goto(rArena1);
}

/// @description Vertical spacing between menu option baselines (matches main menu).
function gui_menu_line_height() {
	return string_height("M") + 18;
}

/// @description Y position for bottom hint text (UP/DOWN, ESC, etc.).
function gui_menu_hint_y(_gh) {
	return _gh - 72;
}

/// @description Draw footer hint; uses same grey and position as main menu.
function gui_menu_draw_hint(_cx, _gh, _hint_text) {
	draw_set_halign(fa_center);
	draw_set_valign(fa_top);
	draw_set_color(make_color_rgb(160, 168, 180));
	draw_text(_cx, gui_menu_hint_y(_gh), _hint_text);
}

/// @description One menu row: orange outline + panel when selected, dim text when not (main menu style).
function gui_menu_draw_option(_cx, _text_y_top, _label, _selected) {
	var _pad_x = 28;
	var _pad_y = 10;
	var _panel = make_color_rgb(28, 28, 34);
	var _accent = make_color_rgb(255, 118, 42);
	var _text_dim = make_color_rgb(160, 168, 180);
	var _text_hi = make_color_rgb(240, 242, 248);

	draw_set_halign(fa_center);
	draw_set_valign(fa_top);

	var _w = string_width(_label) + _pad_x * 2;
	var _h = string_height(_label) + _pad_y * 2;
	var _x1 = _cx - _w * 0.5;
	var _y1 = _text_y_top - _pad_y;
	var _x2 = _x1 + _w;
	var _y2 = _y1 + _h;

	if (_selected) {
		draw_set_color(c_black);
		draw_rectangle(_x1 - 3, _y1 - 3, _x2 + 3, _y2 + 3, false);
		draw_set_color(_panel);
		draw_rectangle(_x1, _y1, _x2, _y2, false);
		draw_set_color(_accent);
		draw_rectangle(_x1, _y1, _x2, _y2, true);
		draw_set_color(_text_hi);
	} else {
		draw_set_color(_text_dim);
	}

	draw_text(_cx, _text_y_top, _label);
}
