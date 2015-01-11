open Btio

type display = {
	io: Btio.io;
	mutable title: string;
	mutable author: string;
}

let getTitle display = display.title
let setTitle display title = display.title <- title

let getAuthor display = display.author
let setAuthor display author = display.author <- author




let init () = {
	io = Btio.init ();
	title = "/\\\\ Bermuda Triangle //\\";
	author = "author"
}

let quit display = Btio.stop display.io



let drawBasicDecoration display =
	Btio.box display.io

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


let drawFrame display =
	let io = display.io in
	let (width, height) = Btio.size io in
	Btio.clear io;
	drawBasicDecoration display;
	drawTitle display width;
	drawAuthor display width height;
	Btio.refresh io