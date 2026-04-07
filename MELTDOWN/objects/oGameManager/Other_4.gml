pause = false;
if (instance_exists(oPauseManager)) {
	with (oPauseManager) instance_destroy();
}
