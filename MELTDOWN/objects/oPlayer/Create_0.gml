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

// Heat (life support — drain over time, gain from pickups/campfires)
max_heat = 100;
heat = max_heat;
heat_drain_per_sec = 4;
freeze_damage_per_sec = 6;

// Pickup magnet (pull heat pickups from further away)
magnet_range = 128;
magnet_strength = 0.80;

// Equip weapon (single weapon, Brotato-style)
weapon = instance_create_layer(x, y, "Instances", oWeapon);
weapon.owner = id;
weapon.depth = depth - 1;