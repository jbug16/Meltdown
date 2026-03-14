// Ice patch created by snowmen - creates slippery surface
// Duration and radius set by creator
duration = 30;  // Default duration in seconds (longer when no enemies) - can be overridden
radius = 32;  // Default radius (can be overridden)

// Store initial duration for fade calculations
initial_duration = duration;

// Lifetime timer
lifetime = duration * SECOND;

// Melting modifiers
enemy_protection_range = 128;  // Range to check for nearby enemies
campfire_melt_range = 96;  // Range to check for nearby campfires
campfire_melt_multiplier = 3.0;  // How much faster ice melts near campfires
projectile_slow_range = 80;  // Range to check for nearby projectiles
projectile_slow_multiplier = 0.3;  // How much slower ice melts near projectiles (0.3 = 70% slower)
projectile_melt_amount = 5 * SECOND;  // How much lifetime to remove when hit by projectile

// Visual properties
image_alpha = 0.6;  // Semi-transparent ice effect
image_blend = c_white;

// Scale sprite to match radius (assuming sprite is 64x64, adjust as needed)
var sprite_size = 64;  // Default sprite size
image_xscale = (radius * 2) / sprite_size;
image_yscale = (radius * 2) / sprite_size;
