open Btio
open Thread

let main () =
	let io = Btio.init () in (
	Btio.clear io;
	Btio.box io;
	Btio.printStringC 
			(string_of_int (Btio.colorPairs ())) 10 3
			Btio.color_red Btio.color_blue;
	Btio.printString "test" 10 5;
	Btio.printStringCenterC "test2" 10 7 Btio.color_red Btio.color_black;
	Btio.refresh io;
	Thread.delay 3.0;
	Btio.stop io
	);;

main ()