//==============================================
// GLOBALS
//==============================================

global.dev_mode = true;

//==============================================
// ENUMS
//==============================================

enum EntityState {
	Alive,
	Dead
}

//==============================================
// MACROS
//==============================================

#macro SECOND 60
#macro DEFAULT_PROJECTILE_DAMAGE 10
#macro ICE_GRID_SIZE 64  // Grid cell size for ice snapping

#macro PRINT show_debug_message