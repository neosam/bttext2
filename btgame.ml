type game = {
	mutable running: bool;
}

(* Map implementations *)
type color = int
let color_black = 0
let color_red = 1
let color_green = 2
let color_yellow = 3
let color_blue = 4
let color_magenta = 5
let color_cyan = 6
let color_white = 7



(* The main modules *)
let init () = {running = true}
let quit game = game.running <- false

let step game = ()
let isDone game = not game.running



(* Actor submodule *)
module Actor = struct
	type actor = {
		mutable name : string;
		mutable displayColor: color;
		mutable mapChar : char;
		mutable mapFg : color;
		mutable mapBg : color;
	}

	let newActor () = {
		name = "unknown";
		displayColor = color_white;
		mapChar = 'X';
		mapFg = color_white;
		mapBg = color_black;
	}
end


(* Define the Map submodule *)
module Map = struct
	type trigger = 
		| None of unit
		| Func of (game -> unit)

	type field = {
		mutable ascii: char;
		mutable fg: color;
		mutable bg: color;
		mutable walkable: bool;
		mutable trigger: trigger;
	}

	type gameMap = {
		width: int;
		height: int;
		fields: field list;
	}


	let newEmptyField () = {
		ascii = ' ';
		fg = color_white;
		bg = color_black;
		walkable = true;
		trigger = None ()
	}

	let newMap width height = 
		let size = width * height in
		let rec createList lst = function
		| 0 -> lst
		| x -> createList ((newEmptyField ()) :: lst) (x - 1)
		in {width = width; height = height; fields = (createList [] size)}
end;;



