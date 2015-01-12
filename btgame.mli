

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
	val getName: 'a actor -> string
	val setName: 'a actor -> string -> unit
	val getColor: 'a actor -> color
	val setColor: 'a actor -> color -> unit
end

(* Map implementations *)
module Map : sig
	type 'a field
	type 'a gameMap

	(* newMap width height
	   create a new map with the given size.
	   The fields are initialized with default values *)
	val getAscii: 'a field -> char
	val setAscii: 'a field -> char -> unit
	val getFg: 'a field -> color
	val setFg: 'a field -> color -> unit
	val getBg: 'a field -> color
	val setBg: 'a field -> color -> unit

	val newMap: int -> int -> 'a gameMap
	val fieldAt: 'a gameMap -> int -> int -> 'a field
end

(* The observer functions *)
type 'a sayListener = ('a Actor.actor -> string -> unit)
type actionListener = (string -> unit)

(* Main type for game storage *)
type game

type gameMap = game Map.gameMap

(* Initialize the game *)
val init: unit -> game
(* Stop game *)
val quit: game -> unit

(* Calculation for one frame *)
val step: game -> unit
(* Check if game is finished *)
val isDone: game -> bool

val getMap: game -> gameMap
val setMap: game -> gameMap -> unit

val registerSayListener: game -> game sayListener -> unit
val registerActionListener: game -> actionListener -> unit

val say: game -> game Actor.actor -> string -> unit
val action: game ->string -> unit

