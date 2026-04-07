if (game_over) {
	game_restart_run();
	exit;
}

if (room != rArena1 && room != rArena2 && room != rArena3) exit;

pause = !pause;

if (pause) {
	if (!instance_exists(oPauseManager)) {
		instance_create_depth(0, 0, -1600, oPauseManager);
	}
} else {
	with (oPauseManager) instance_destroy();
}
