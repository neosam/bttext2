open Btrender

type btdisplay

type btrender = Btrender.btrender
type field = string * string

val init: btrender option -> btdisplay
val quit: btdisplay -> btdisplay

(* Status display field *)
val add_field: field -> btdisplay -> btdisplay
val set_field: string -> string -> btdisplay -> btdisplay

val clear_fields: btdisplay -> btdisplay

val set_title: string -> btdisplay -> btdisplay
val get_title: btdisplay -> string

val set_chapter: string -> btdisplay -> btdisplay
val get_chapter: btdisplay -> string

val set_status_size: int -> btdisplay -> btdisplay
val get_status_size: btdisplay -> int

val set_text_map_ratio: int * int -> btdisplay -> btdisplay
val get_text_map_ratio: btdisplay -> int * int


val render_frame: btdisplay -> btdisplay
