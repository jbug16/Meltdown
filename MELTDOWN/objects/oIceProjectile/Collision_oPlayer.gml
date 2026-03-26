if (!instance_exists(other)) exit;
if (other.state == EntityState.Dead) exit;

player_damage(damage);
instance_destroy();
