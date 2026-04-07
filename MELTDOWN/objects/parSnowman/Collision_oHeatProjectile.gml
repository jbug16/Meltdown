if (game_is_paused()) exit;

// Ignore if dead
if (state == EntityState.Dead) exit;

// Take damage (pass direction for knockback)
take_damage(other.damage, other.direction);

// Destroy projectile
with (other) instance_destroy();