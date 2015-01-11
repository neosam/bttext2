open Terminal
open Thread

let main () =
	let io = Terminal.init () in (
	Terminal.clear io;
	Terminal.box io;
	Terminal.printStringColor 
			(string_of_int (Terminal.colorPairs ())) 10 3
			Terminal.color_red Terminal.color_blue;
	Terminal.printString "test" 10 5;
	Terminal.printStringColor "test2" 10 7 Terminal.color_red Terminal.color_black;
	Terminal.refresh io;
	Thread.delay 3.0;
	Terminal.stop io
	);;

main ()