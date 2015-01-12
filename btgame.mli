

(* Other ingame types *)
type color
val color_black : color
val color_red : color
val color_green : color
val color_yellow : color
val color_blue : color
val color_magenta : color
val color_cyan : color
val color_white : color




(* Actor implementation *)
module Actor : sig
	type 'a trigger
	type 'a actor
	type 'a actorStorage

	val newActor: unit -> 'a actor
	val newActorStorage: unit -> 'a actorStorage
end

(* Map implementations *)
module Map : sig
	type 'a field
	type 'a gameMap

	(* newMap width height
	   create a new map with the given size.
	   The fields are initialized with default values *)
	val newMap: int -> int -> 'a gameMap
end

(* Main type for game storage *)
type game

(* Initialize the game *)
val init: unit -> game
(* Stop game *)
val quit: game -> unit

(* Calculation for one frame *)
val step: game -> unit
(* Check if game is finished *)
val isDone: game -> bool
