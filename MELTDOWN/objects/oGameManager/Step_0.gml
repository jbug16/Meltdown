var _pl = instance_find(oPlayer, 0);
if (_pl != noone && _pl.state == EntityState.Dead && !game_over) {
	game_over = true;
	game_over_menu_index = 0;
	pause = false;
	var _pm = instance_find(oPauseManager, 0);
	if (_pm != noone) instance_destroy(_pm);
}

if (game_over) {
	var _n = 3;
	if (keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"))) {
		game_over_menu_index = (game_over_menu_index - 1 + _n) mod _n;
	}
	if (keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"))) {
		game_over_menu_index = (game_over_menu_index + 1) mod _n;
	}
	var _go = keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space);
	if (_go) {
		switch (game_over_menu_index) {
			case 0:
				game_restart_run();
				break;
			case 1:
				game_over = false;
				pause = false;
				room_goto(rMainMenu);
				exit;
			case 2:
				game_end();
				exit;
		}
	}
	exit;
}

if (game_is_paused()) exit;

// Debug controls
if (global.dev_mode && keyboard_check_pressed(ord("H"))) {
	player_damage(25);
}

if (keyboard_check_pressed(ord("R")) && global.dev_mode) {
	game_restart_run();
}

if (global.dev_mode && keyboard_check_pressed(vk_f12)) {
	game_end();
}