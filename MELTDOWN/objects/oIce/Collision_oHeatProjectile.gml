if (game_is_paused()) exit;

// Ice melts when hit by fire projectiles
// Reduce lifetime (melt faster)
lifetime -= projectile_melt_amount;
