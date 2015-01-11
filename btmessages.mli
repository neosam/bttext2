open Btio

(* A single message *)
type message

(* The whole message field *)
type messageField



(* Creates an empty message *)
val newMessage: unit -> message

(* Add text in foreground and background color *)
val addTextToMessage: message -> string -> Btio.color -> Btio.color -> unit
(* Separate by space and insert each word *)
val addWordsToMessage: message -> string -> Btio.color -> Btio.color -> unit

(* Create new message field *)
val newMessageField: unit -> messageField

(* Add message to message field *)
val addMessageToField: messageField -> message -> unit

(* Display the field *)
val draw: Btio.io -> messageField -> int -> int -> int -> int -> int