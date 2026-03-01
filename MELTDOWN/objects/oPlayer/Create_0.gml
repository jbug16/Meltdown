// Brotato-style top-down movement — init
move_speed = 5;

// Health (hp to avoid built-in "health")
max_hp = 100;
hp = max_hp;
state = EntityState.Alive;
accel = 0.45;
decel = 0.35;
hsp = 0;
vsp = 0;

// Equip weapon (single weapon, Brotato-style)
weapon = instance_create_layer(x, y, "Instances", oWeapon);
weapon.owner = id;
weapon.depth = depth - 1;
