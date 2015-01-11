type display

val getTitle: display -> string
val setTitle: display -> string -> unit
val getAuthor: display -> string 
val setAuthor: display -> string -> unit 


val init: unit -> display
val quit: display -> unit

val drawFrame: display -> unit