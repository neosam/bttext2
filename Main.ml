open Btdisplay
open Btgame


let main () =
	let game = Btgame.init () in
	let d = Btdisplay.init game in
	Btdisplay.gameloop d;
	Btdisplay.quit d;;

main ()