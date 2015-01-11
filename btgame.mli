type game

val init: unit -> game
val quit: game -> unit

val step: game -> unit
val isDone: game -> bool