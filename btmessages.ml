open Btio
open List
open Str


type messagePart = {
	text: string;
	fg: Btio.color;
	bg: Btio.color;
}

(* A single message *)
type message = {
	mutable parts: messagePart list;
}

(* The whole message field *)
type messageField = {
	mutable messages: message list;
}



(* Creates an empty message *)
let newMessage () = {parts = []}

(* Add text in foreground and background color *)
let addTextToMessage msg text fg bg = msg.parts <- List.append msg.parts [{
	text = text; fg = fg; bg = bg; }]

let addWordsToMessage msg text fg bg =
	let rec aux = function
	| [] -> ()
	| word :: t -> (
		addTextToMessage msg word fg bg;
		aux t)
	in aux (Str.split (Str.regexp " ") text)

(* Create new message field *)
let newMessageField () = {messages = []}

(* Add message to message field *)
let addMessageToField msgField msg = 
	msgField.messages <- msg :: msgField.messages


let getHeight io msg x y w h = 
	let rec aux i h = function
	| [] -> h
	| word :: t as all -> 
		let diff = w - i
		and wordLen = String.length word.text in
		if wordLen < diff then aux (i + wordLen + 1) h t
		else if h > 0 then aux x (h - 1) all
		else 0 
	in aux x h msg.parts;;

let drawMessage io msg x y w h maxH = 
	let rec aux i h = function
	| [] -> h
	| word :: t as all -> (
		let diff = w - i
		and wordLen = String.length word.text in
		if wordLen < diff then (
			Btio.printStringC io word.text i (y + h) word.fg word.bg;
			aux (i + wordLen + 1) h t)
		else 
			if h < maxH then aux x (h + 1) all
			else 0 )
	in aux x h msg.parts;;


let draw io msgField x y w h =
	let rec aux h = function
	| [] -> 0
	| msg :: t -> 
		if h > 0 then 
			let newHeight = getHeight io msg x y w (h - 1) in
			if newHeight >= 0 then aux (drawMessage io msg x y w newHeight h) t else 0
		else 0
	in aux h msgField.messages