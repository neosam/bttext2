open Btrender

type btdisplay

type btrender = Btrender.btrender

val init: btrender option -> btdisplay
val quit: btdisplay -> btdisplay

(* Status display field *)
(* Add a string field:  add_string_field *)
val add_string_field: string -> string -> btdisplay -> btdisplay
val add_int_field: string -> int -> btdisplay -> btdisplay

(* set_string_field name value display *)
val set_string_field: string -> string -> btdisplay -> btdisplay
(* set_int_field name vlaue display *)
val set_int_field: string -> int -> btdisplay -> btdisplay

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
