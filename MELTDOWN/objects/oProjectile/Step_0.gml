// Move in facing direction; destroy when off-room
image_angle = direction;
x += lengthdir_x(speed, direction);
y += lengthdir_y(speed, direction);

if (x < -32 || x > room_width + 32 || y < -32 || y > room_height + 32) {
	instance_destroy();
}
