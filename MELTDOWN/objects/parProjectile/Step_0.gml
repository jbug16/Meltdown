if (game_is_paused()) exit;

// Move in facing direction
image_angle = direction;
x += lengthdir_x(speed, direction);
y += lengthdir_y(speed, direction);

// Destroy when out of room
if (x < -32 || x > room_width + 32 || y < -32 || y > room_height + 32) {
	instance_destroy();
}