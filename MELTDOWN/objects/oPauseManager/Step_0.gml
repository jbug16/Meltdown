var _n = 4;

if (keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"))) {
	menu_index = (menu_index - 1 + _n) mod _n;
}
if (keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"))) {
	menu_index = (menu_index + 1) mod _n;
}

var _go = keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space);
if (!_go) exit;

var _gm = instance_find(oGameManager, 0);

switch (menu_index) {
	case 0:
		if (_gm != noone) _gm.pause = false;
		instance_destroy();
		break;
	case 1:
		game_restart_run();
		break;
	case 2:
		if (_gm != noone) _gm.pause = false;
		instance_destroy();
		room_goto(rMainMenu);
		break;
	case 3:
		game_end();
		break;
}
