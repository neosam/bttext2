open Btdisplay
open Thread

let main () =
	let d = Btdisplay.init () in (
	Btdisplay.drawFrame d;
	Thread.delay 3.0;
	Btdisplay.quit d
	);;

main ()