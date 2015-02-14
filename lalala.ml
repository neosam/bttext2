open Btdisplay
open Btgame


let action game =
    (* Define some sample scenario:
        Lalala, the choco elfin enters the gingerbreadhouse.
        So we need the lalala and the witch actor and let them talk.
        And then we initialize their values and finally perform the action.
    *)
    let lalala = Btgame.Actor.newActor ()
    and witch = Btgame.Actor.newActor () in

    (* Define the actor's attributes *)
    Btgame.Actor.setName lalala "Lalala";
    Btgame.Actor.setColor lalala Btgame.color_blue;
    Btgame.Actor.setPos lalala (1, 0);
    Btgame.Actor.setAscii lalala 'L';
    Btgame.Actor.setBg lalala Btgame.color_blue;
    Btgame.Actor.setName witch "The Witch";
    Btgame.Actor.setColor witch Btgame.color_red;
    Btgame.Actor.setPos witch (0, 1);
    Btgame.Actor.setAscii witch 'W';
    Btgame.Actor.setFg witch Btgame.color_red;
    Btgame.addActor game lalala;
    Btgame.addActor game witch;
    Btgame.setPlayer game lalala;

    (* And action! *)
    Btgame.action game ("You are entering the tasty gingerbread house.  " ^
                        "Wow!  It's made out of gingerbread!");
    Btgame.say game lalala "Hello!";
    Btgame.say game witch "Heeellooooo!   Gnihihihihi";
    Btgame.say game lalala "Hihi";
    Btgame.action game "Kill the witch!"


let setup d game =
    (* Register callback functions *)
    (* If somebody says something *)
    Btgame.registerSayListener game (fun actor text ->
            let msg = Btmessages.newMessage () in begin
            Btmessages.addWordsToMessage msg
                ((Btgame.Actor.getName actor) ^ ":")
                (Btdisplay.gameToIoColor (Btgame.Actor.getColor actor)) 
                                            Btio.color_black;
            Btmessages.addWordsToMessage msg text Btio.color_green
                                            Btio.color_black;
            Btmessages.addMessageToField 
                (Btdisplay.getMessageField d) msg;
        end
    );

    (* If any action happens (just text output) *)
    Btgame.registerActionListener game (fun text ->
        let msg = Btmessages.newMessage () in
        Btmessages.addWordsToMessage msg text Btio.color_white
                                              Btio.color_black;
        Btmessages.addMessageToField 
            (Btdisplay.getMessageField d) msg;
    );

    Btgame.setMap game (Btgame.Map.newMap 100 100);
    Btgame.Map.setAscii (Btgame.Map.fieldAt (Btgame.getMap game) 2 2) 'G';
    Btgame.Map.setFg (Btgame.Map.fieldAt (Btgame.getMap game) 3 3)
                                         Btgame.color_blue;
    Btgame.Map.setBg (Btgame.Map.fieldAt (Btgame.getMap game) 5 3)
                                         Btgame.color_blue;
    Btgame.Map.setWalkable (Btgame.Map.fieldAt (Btgame.getMap game) 2 2) false;
    let fieldTrigger game = begin
        Btgame.action game "Trigger touched";
        (*Btgame.goDown game |> ignore;*)
    end
    in begin
        Btgame.addTrigger game "test1" fieldTrigger;
    end;
    Btgame.Map.setTrigger (Btgame.Map.fieldAt (Btgame.getMap game) 5 3)
                          (MapTriggerId "test1");

    for i = 0 to 10 do
        begin
            Btgame.Map.setAscii (Btgame.Map.fieldAt
                                    (Btgame.getMap game) i 0) ' ';
            Btgame.Map.setAscii (Btgame.Map.fieldAt
                                    (Btgame.getMap game) 0 i) ' ';
        end
    done;

    (* Some basic setup *)
    Btdisplay.setTitle d "| Story of Lalala |";
    Btdisplay.setAuthor d "neosam";

    (* Do some action to test the engine*)
    action game

(*let setup display =
    (* setup code here *)
    ()*)

