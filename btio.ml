open Curses

(* Structure which holds the important data *)
type io = {
    window: Curses.window
}


(* Some color difinition *)
type color = int
let color_black = 0
let color_red = 1
let color_green = 2
let color_yellow = 3
let color_blue = 4
let color_magenta = 5
let color_cyan = 6
let color_white = 7

let encColorPair fg bg = bg * 8 + fg
let decColorPair x = (x mod 8, x / 8)

let initColors () =
	Curses.start_color ();
	for bg = 0 to 7 do 
		for fg = 0 to 7 do
			init_pair (encColorPair fg bg) fg bg
		done 
	done

(* Initialize the system *)
let init () = 
	let window = Curses.initscr () in (
	initColors ();
	{window = window})

(* Stop the system *)
let stop io = Curses.endwin ()

(* Clear the window *)
let clear io = Curses.werase io.window; ()

(* Paint the new content *)
let refresh io = Curses.refresh (); ()

(* Revert the size, 
	to have width at first parameter and height as second *)
let size io = 
	let (height, width) = Curses.get_size () in
	(width, height)


let box io = Curses.box io.window 0 0

let vline io x y n = mvvline y x 0 n

let printString io text x y = 
	Curses.mvaddstr y x text;
	()

let printStringC io text x y fg bg =
	let color = encColorPair fg bg in (
	Curses.attr_set 0 color;
	printString io text x y)

let printStringCenterC io text x y fg bg =
	let x = x - String.length text / 2 in
	printStringC io text x y fg bg

let printStringRightC io text x y fg bg =
	let x = x - String.length text in
	printStringC io text x y fg bg

let colorPairs () = Curses.color_pairs ()