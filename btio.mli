type io

type color
val color_black : color
val color_red : color
val color_green : color
val color_yellow : color
val color_blue : color
val color_magenta : color
val color_cyan : color
val color_white : color


val init : unit -> io
val stop : io -> unit
val clear : io -> unit
val refresh : io -> unit
val size : io -> int * int

val box : io -> unit
val vline : io -> int -> int -> int -> unit
val printString : io -> string -> int -> int -> unit
val printStringC : io -> string -> int -> int -> color -> color -> unit
val printStringCenterC : io -> string -> int -> int -> color -> color -> unit
val printStringRightC : io -> string -> int -> int -> color -> color -> unit

val colorPairs : unit -> int