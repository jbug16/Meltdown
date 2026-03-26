// Follow owner, aim at mouse, shoot with cooldown
if (!instance_exists(owner)) {
	instance_destroy();
	exit;
}

// Ignore if dead
if (owner.state == EntityState.Dead) exit;

// Aim using mouse position
var aim = point_direction(owner.x, owner.y, mouse_x, mouse_y);
image_angle = aim;

// Offset to the side so it looks held (e.g. right hand), not centered on player
x = owner.x + lengthdir_x(hold_offset, aim - 90);
y = owner.y + lengthdir_y(hold_offset, aim - 90);

shot_timer = max(0, shot_timer - 1);
var shot_cooldown = SECOND / fire_rate;

// Shoot
if (mouse_check_button_pressed(mb_left) && shot_timer <= 0) {
	var dir = point_direction(x, y, mouse_x, mouse_y);
	var spawn_x = x + lengthdir_x(muzzle_offset, dir);
	var spawn_y = y + lengthdir_y(muzzle_offset, dir);
	var proj = instance_create_layer(spawn_x, spawn_y, "Instances", oHeatProjectile);
	
	proj.direction = dir;
	proj.speed = 14;
	proj.owner = owner;
	proj.damage = DEFAULT_PROJECTILE_DAMAGE;
	
	shot_timer = shot_cooldown;
}
