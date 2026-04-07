if (menu_input_cooldown > 0) menu_input_cooldown--;

var _nav = (keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S")))
	- (keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W")));

if (_nav != 0) {
	if (menu_input_cooldown <= 0) {
		menu_selection = (menu_selection + _nav + menu_count) mod menu_count;
		menu_input_cooldown = 12;
	}
}

if (keyboard_check_pressed(vk_escape)) {
	game_end();
}

if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space)) {
	switch (menu_selection) {
		case 0:
			game_restart_run();
			break;
		case 1:
			game_end();
			break;
	}
}
