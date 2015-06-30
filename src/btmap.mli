open Btio
open Btrender
open Quadtree

type btfield
type btmap

(* --- Basic field functions *)
(* let create_field c (fg bg) (x y) *)
val create_field: char -> Btio.color_pair -> bool -> string option -> btfield

(* let set_char c char *)
val set_char: char -> btfield -> btfield
val get_char: btfield -> char

(* let set_color *)
val set_color: Btio.color_pair -> btfield -> btfield
val get_color: btfield -> Btio.color_pair



(* --- Basic map functions *)
(* let create_map (width, height) default_field *)
val create_map:
               int * int ->
               int * int ->
               btrender ->
                 btmap

val set_render: btrender -> btmap -> btmap
val set_map: (btfield, unit) Quadtree.map -> btmap -> btmap

(* field at *)
val field_at: int * int -> btmap -> btfield
val set_field: int * int -> btfield -> btmap -> btmap

(* Rendering *)
val render: btmap -> btmap
