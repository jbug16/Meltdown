if (!global.dev_mode) exit;

// Debug stats
var _start_x = 20;
var _start_y = 20;
var _line = 20;

if (instance_exists(oPlayer)) {
	draw_text(_start_x, _start_y, $"hp: {oPlayer.hp} / {oPlayer.max_hp}");
	_start_y += _line;
	draw_text(_start_x, _start_y, oPlayer.state == EntityState.Dead ? "DEAD" : "alive");
	_start_y += _line;
	draw_text(_start_x, _start_y, $"vsp: {oPlayer.vsp}");
	_start_y += _line;
	draw_text(_start_x, _start_y, $"hsp: {oPlayer.hsp}");
}