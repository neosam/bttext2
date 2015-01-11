open Btgame

type display

val getTitle: display -> string
val setTitle: display -> string -> unit
val getAuthor: display -> string 
val setAuthor: display -> string -> unit 


val init: Btgame.game -> display
val setup: display -> unit
val quit: display -> unit

val drawFrame: display -> unit
val doFrame: display -> unit
val gameloop: display -> unit