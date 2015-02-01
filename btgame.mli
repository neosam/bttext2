

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
    type trigger
    type actor
    type actorStorage

    val newActor: unit -> actor
    val newActorStorage: unit -> actorStorage
    val getName: actor -> string
    val setName: actor -> string -> unit
    val getColor: actor -> color
    val setColor: actor -> color -> unit
    val getPos: actor -> (int * int)
    val setPos: actor -> (int * int) -> unit
    val getAscii: actor -> char
    val setAscii: actor -> char -> unit
    val getFg: actor -> color
    val setFg: actor -> color -> unit
    val getBg: actor -> color
    val setBg: actor -> color -> unit
end

(* Map implementations *)
module Map : sig
    type trigger =
        | None of unit
        | MapTriggerId of string
    type field
    type gameMap

    (* newMap width height
       create a new map with the given size.
       The fields are initialized with default values *)
    val getAscii: field -> char
    val setAscii: field -> char -> unit
    val getFg: field -> color
    val setFg: field -> color -> unit
    val getBg: field -> color
    val setBg: field -> color -> unit
    val isWalkable: field -> bool
    val setWalkable: field -> bool -> unit
    val getTrigger: field -> trigger
    val setTrigger: field -> trigger -> unit

    val newMap: int -> int -> gameMap
    val fieldAt: gameMap -> int -> int -> field
    val getFocus: gameMap -> (int * int)
end

(* The observer functions *)
type sayListener = (Actor.actor -> string -> unit)
type actionListener = (string -> unit)

type 'a trigger = ('a -> unit)

(* Main type for game storage *)
type game

type gameMap = Map.gameMap

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

val addActor: game -> Actor.actor -> unit

val getActorList: game -> Actor.actor list

val registerSayListener: game -> sayListener -> unit
val registerActionListener: game -> actionListener -> unit
val addStepCallback: game -> callback -> unit
val removeStepCallback: game -> callback -> unit

val say: game -> Actor.actor -> string -> unit
val action: game -> string -> unit

val addTrigger: game -> string -> game trigger -> unit
val getTrigger: game -> string -> game trigger
val runTrigger: game -> (int * int) -> unit

val getCollision: game -> bool
val setCollision: game -> bool -> unit
val getRunTrigger: game -> bool
val setRunTrigger: game -> bool -> unit

val setPlayer: game -> Actor.actor -> unit
val goLeft: game -> bool
val goRight: game -> bool
val goUp: game -> bool
val goDown: game -> bool


