open Btio
open Thread
open Btgame


type player_attributes = {
	mutable name: string;
	mutable hpMax: int;
	mutable hp: int;
}

type display = {
	io: Btio.io;
	mutable title: string;
	mutable author: string;
	game: game;

	msgMapSplit: int * int;
	playerAttr: player_attributes;
}

let getTitle display = display.title
let setTitle display title = display.title <- title

let getAuthor display = display.author
let setAuthor display author = display.author <- author




let init game = {
	io = Btio.init ();
	title = "/\\\\ Bermuda Triangle //\\";
	author = "author";
	msgMapSplit = (3, 4);
	playerAttr = {
		name = "Mike";
		hpMax = 100;
		hp = 100;
	};
	game = game;
}

let quit display = Btio.stop display.io



let drawBasicDecoration display width height =
	let io = display.io 
	and (splitA, splitB) = display.msgMapSplit in
	let mapX = width * splitA / splitB in
	Btio.box io;
	Btio.vline io mapX 4 (height - 6);
	Btio.printStringC io "Messages:" 2 4
			Btio.color_white Btio.color_black;
	Btio.printStringC io "Map:" (mapX + 2) 4
			Btio.color_white Btio.color_black
	 

let drawTitle display width =
	Btio.printStringCenterC display.io 
			display.title (width / 2) 0 
			Btio.color_white Btio.color_black

let drawAuthor display width height =
	let x = width - 1
	and y = height - 1 in
	Btio.printStringRightC display.io
			display.author x y
			Btio.color_white Btio.color_black

let drawStatus display =
	Btio.printStringC display.io
			"State:" 2 2 Btio.color_white Btio.color_black



let drawFrame display =
	let io = display.io in
	let (width, height) = Btio.size io in
	Btio.clear io;
	drawBasicDecoration display width height;
	drawTitle display width;
	drawAuthor display width height;
	drawStatus display;
	Btio.refresh io


let handleInput display =
	let key = Btio.getKey display.io in
	if key = Btio.key_q then Btgame.quit display.game


let doFrame display =
	handleInput display;
	Btgame.step display.game


let gameloop display =
	let rec aux () = 
		Thread.delay 0.1;
		doFrame display;
		drawFrame display;
		if Btgame.isDone display.game = false then aux ()
	in aux ()
