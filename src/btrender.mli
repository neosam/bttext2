(* Overlay of the Btio module *)
open Btio

(* The io type is widely used in this module, so lets create a shortcut *)
type btio = Btio.io

(* Lets have a monad type *)
type btrender


val unpack_io: btrender -> btio
val pack_io: btio -> btrender -> btrender

(* The init function.
 * This function will initialize Btio, initialize the internal objects
 * and finally return the new btrender value.  
 *)
val init: unit -> btrender

(* Stop all systems *)
val quit: btrender -> btrender

(* Refresh function to draw the new content *)
val refresh: btrender -> btrender

(* Return the terminal size *)
val size: btrender -> int * int

(* Draw a box at the window edges *)
val box: btrender -> btrender

(* Vertical line *)
val vline: int -> int * int -> btrender -> btrender

(* Horiozontal line *)
val hline: int -> int * int -> btrender -> btrender

(* Print a character *)
val print_char: Btio.color_pair option -> char -> int * int -> btrender 
                    -> btrender

(* Print a string *)
val print_string: Btio.color_pair option -> string -> int * int ->
                    btrender -> btrender

(* Print centered string *)
val print_string_center: Btio.color_pair option -> string -> int * int ->
                    btrender -> btrender

(* Print recht oriented string *)
val print_string_right: Btio.color_pair option -> string -> int * int ->
                    btrender -> btrender

val get_key: btrender -> Btio.key
