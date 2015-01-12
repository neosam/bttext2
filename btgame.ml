
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







(* Actor submodule *)
module Actor = struct
	type 'a trigger = 
		| None of unit
		| Func of ('a -> unit)

	type 'a actor = {
		mutable name : string;
		mutable displayColor: color;
		mutable mapChar : char;
		mutable mapFg : color;
		mutable mapBg : color;
		mutable touchAction : 'a trigger;
	}

	type 'a actorStorage = 'a actor list

	let newActor () = {
		name = "unknown";
		displayColor = color_white;
		mapChar = 'X';
		mapFg = color_white;
		mapBg = color_black;
		touchAction = None ();
	}

	let getName actor = actor.name
	let setName actor name = actor.name <- name
	let getColor actor = actor.displayColor
	let setColor actor color = actor.displayColor <- color

	let newActorStorage () = []
end


(* Define the Map submodule *)
module Map = struct
	type 'a trigger = 
		| None of unit
		| Func of ('a -> unit)

	type 'a field = {
		mutable ascii: char;
		mutable fg: color;
		mutable bg: color;
		mutable walkable: bool;
		mutable trigger: 'a trigger;
	}

	type 'a gameMap = {
		width: int;
		height: int;
		fields: 'a field list;
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


(* The observer functions *)
type 'a sayListener = ('a Actor.actor -> string -> unit)
type actionListener = (string -> unit)


type game = {
	mutable running: bool;
	mutable map: game Map.gameMap;
	actorStorage: game Actor.actorStorage;
	mutable sayListener: game sayListener;
	mutable actionListener: actionListener;
}


(* The main modules *)
let init () = {
	running = true;
	map = Map.newMap 1 1;
	actorStorage = Actor.newActorStorage ();
	sayListener = (fun x y -> ());
	actionListener = (fun x -> ());
}
let quit game = game.running <- false

let step game = ()
let isDone game = not game.running


let registerSayListener game listener = game.sayListener <- listener
let registerActionListener game listener = game.actionListener <- listener

let say game actor text =
	game.sayListener actor text
let action game text =
	game.actionListener text


