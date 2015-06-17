open Btio
open Btrender

type textblock
type bttextfield

(* --- Basic default functions *)
val create: int * int -> int * int -> btrender -> bttextfield
val resize: int * int -> bttextfield -> bttextfield
val set_render: Btrender.btrender -> bttextfield -> bttextfield
val get_btrender: bttextfield -> btrender

(* --- Textblock functions *)
val create_textblock: string -> Btio.color_pair -> textblock

(* --- Lowlevel function *)
val add_textblock: textblock -> bttextfield -> bttextfield
val add_newline: bttextfield -> bttextfield

(* --- Midlevel functions *)
val add_textblocks: textblock list -> bttextfield -> bttextfield

(* --- Highlevel functions *)
val add_string: Btio.color_pair -> string -> bttextfield -> bttextfield


(* --- Rendering *)
val render: bttextfield -> bttextfield
