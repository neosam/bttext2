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

let box io = Curses.box io.window 0 0

let printString text x y = 
	Curses.mvaddstr y x text;
	()

let printStringColor text x y fg bg =
	let color = encColorPair fg bg in (
	Curses.attr_set 0 color;
	printString text x y)


let colorPairs () = Curses.color_pairs ()