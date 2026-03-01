/// @description Apply damage to the player. Handles death when hp reaches 0.
/// @param {real} amount - Damage amount to subtract from hp
function player_damage(amount) {
	var inst = instance_find(oPlayer, 0);
	if (inst == noone) return;

	if (inst.state == EntityState.Dead) return;

	inst.hp -= amount;
	if (inst.hp < 0) inst.hp = 0;

	if (inst.hp <= 0) {
		inst.state = EntityState.Dead;
		// Optional: room_restart(), room_goto(rGameOver), etc.
	}
}

/// @description Add heat to the player (from pickups, campfires). Clamps to max_heat.
/// @param {real} amount - Heat to add
function player_add_heat(amount) {
	var inst = instance_find(oPlayer, 0);
	if (inst == noone) return;
	if (inst.state == EntityState.Dead) return;

	inst.heat = min(inst.heat + amount, inst.max_heat);
}
