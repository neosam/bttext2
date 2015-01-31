open Btdisplay
open Btgame
open Log

let initLog () = begin
    let logfile = open_out "logfile.txt" in
    Log.set_log_level Log.DEBUG;
    Log.set_output logfile;
end;;

let main () = begin
    initLog ();
    Log.info "%s" "Starting";
    let game = Btgame.init () in
    let d = Btdisplay.init game in
    Btdisplay.setup d game;
    Btdisplay.gameloop d;
    Btdisplay.quit d;
    Log.info "%s" "Finish";
end;;

main ()

