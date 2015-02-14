open Btgame
open Btio
open Btdisplay
open Log

let prepareDefaultSettings display game = begin
    Btdisplay.setTitle display "| BT Leveleditor |";
    Btdisplay.setAuthor display "edit";
end;;

let setupCursor game = begin

end;;

let setupEditor display game = begin
    prepareDefaultSettings display game;
    setupCursor game;
end;;

let initLog () = begin
    let logfile = open_out "editorlog.txt" in
    Log.set_log_level Log.DEBUG;
    Log.set_output logfile;
end;;

let main () = begin
    initLog ();
    Log.info "%s" "Editor started";
    let game = Btgame.init () in
    let display = Btdisplay.init game in
    setupEditor display game;
    Btdisplay.gameloop display;
    Btdisplay.quit display;
    Log.info "%s" "Editor done";
end;;

main ()
