var _pl = instance_find(oPlayer, 0);
if (_pl != noone && _pl.state == EntityState.Dead && !game_over) {
	game_over = true;
	pause = false;
	var _pm = instance_find(oPauseManager, 0);
	if (_pm != noone) instance_destroy(_pm);
}

if (game_over) {
	if (keyboard_check_pressed(ord("M"))) {
		game_over = false;
		room_goto(rMainMenu);
	}
}

if (game_is_paused()) exit;

// Debug controls
if (global.dev_mode && keyboard_check_pressed(ord("H"))) {
	player_damage(25);
}

if (keyboard_check_pressed(ord("R")) && (game_over || global.dev_mode)) {
	game_restart();
}

if (global.dev_mode && keyboard_check_pressed(vk_f12)) {
	game_end();
}