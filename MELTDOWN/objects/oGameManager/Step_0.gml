// Debug controls
if (global.dev_mode && keyboard_check_pressed(ord("H"))) {
	player_damage(25);
}

if (global.dev_mode && keyboard_check_pressed(ord("R"))) {
	game_restart();
}

if (global.dev_mode && keyboard_check_pressed(vk_escape)) {
	game_end();
}