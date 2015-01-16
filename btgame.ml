open List

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
	type trigger = 
		| None of unit
		| Id of string

	type actor = {
		mutable name : string;
		mutable displayColor: color;
		mutable pos : int * int;
		mutable mapChar : char;
		mutable mapFg : color;
		mutable mapBg : color;
		mutable touchAction : trigger;
	}

	type actorStorage = actor list

	let newActor () = {
		name = "unknown";
		displayColor = color_white;
		pos = (0, 0);
		mapChar = 'X';
		mapFg = color_white;
		mapBg = color_black;
		touchAction = None ();
	}

	let getName actor = actor.name
	let setName actor name = actor.name <- name
	let getColor actor = actor.displayColor
	let setColor actor color = actor.displayColor <- color
	let getPos actor = actor.pos
	let setPos actor pos = actor.pos <- pos
	let getAscii actor = actor.mapChar
	let setAscii actor ascii = actor.mapChar <- ascii
	let getFg actor = actor.mapFg
	let setFg actor c = actor.mapFg <- c
	let getBg actor = actor.mapBg
	let setBg actor c = actor.mapBg <- c

	let newActorStorage () = []
end


(* Define the Map submodule *)
module Map = struct
	type trigger = 
		| None of unit
		| Id of string

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

		focus: int * int;
	}


	let newEmptyField () = {
		ascii = ' ';
		fg = color_white;
		bg = color_black;
		walkable = true;
		trigger = None ()
	}
	let newOutsideField () = 
		let f = newEmptyField () in
		begin
			f.ascii <- '.';
			f
		end

	let getAscii field = field.ascii
	let setAscii field c = field.ascii <- c
	let getFg field = field.fg
	let setFg field color = field.fg <- color
	let getBg field = field.bg
	let setBg field color = field.bg <- color

	
	let newMap width height = 
		let size = width * height in
		let rec createList lst = function
		| 0 -> lst
		| x -> createList ((newEmptyField ()) :: lst) (x - 1)
		in {
			width = width; 
			height = height; 
			fields = (createList [] size);
			focus = (0, 0);
			}

	let isOutOfBounce map x y =
		if x < 0 then true
		else if x >= map.width then true
		else if y < 0 then true
		else if y >= map.height then true
		else false
	let coordinateToIndex map x y = map.width * y + x
	let fieldAt map x y = 
		if isOutOfBounce map x y then 
			newOutsideField ()
		else
			List.nth map.fields (coordinateToIndex map x y)
	let getFocus map = map.focus
end;;


(* The observer functions *)
type sayListener = (Actor.actor -> string -> unit)
type actionListener = (string -> unit)


type game = {
	mutable running: bool;
	mutable map: Map.gameMap;
	mutable actorStorage: Actor.actorStorage;
	mutable sayListener: sayListener;
	mutable actionListener: actionListener;
	mutable player: Actor.actor;
}

type gameMap = Map.gameMap


(* The main modules *)
let init () = {
	running = true;
	map = Map.newMap 1 1;
	actorStorage = Actor.newActorStorage ();
	sayListener = (fun x y -> ());
	actionListener = (fun x -> ());
	player = Actor.newActor ();
}
let quit game = game.running <- false

let step game = ()
let isDone game = not game.running

let getMap game = game.map
let setMap game map = game.map <- map

let addActor game actor = game.actorStorage <- actor :: game.actorStorage

let getActorList game = game.actorStorage

let registerSayListener game listener = game.sayListener <- listener
let registerActionListener game listener = game.actionListener <- listener

let say game actor text =
	game.sayListener actor text
let action game text =
	game.actionListener text


let setPlayer game player = game.player <- player
let movePlayer game (x, y) =
	let player = game.player in
	let (px, py) = Actor.getPos player in
	Actor.setPos player (px + x, py + y)

let goLeft game = movePlayer game (-1, 0)
let goRight game = movePlayer game (1, 0)
let goUp game = movePlayer game (0, -1)
let goDown game = movePlayer game (0, 1)

