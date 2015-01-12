(* Main type for game storage *)
type game

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


(* Initialize the game *)
val init: unit -> game
(* Stop game *)
val quit: game -> unit

(* Calculation for one frame *)
val step: game -> unit
(* Check if game is finished *)
val isDone: game -> bool


(* Actor implementation *)
module Actor : sig
	type actor

	val newActor: unit -> actor
end

(* Map implementations *)
module Map : sig
	type field
	type gameMap

	(* newMap width height
	   create a new map with the given size.
	   The fields are initialized with default values *)
	val newMap: int -> int -> gameMap
end