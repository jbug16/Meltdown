// Debug controls
if (global.dev_mode && keyboard_check_pressed(ord("H"))) {
	player_damage(25);
}

if (global.dev_mode && keyboard_check_pressed(ord("R"))) {
	game_restart();
}