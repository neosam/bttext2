open Btio
open Thread
open Btgame
open Btmessages


type player_attributes = {
    mutable name: string;
    mutable hpMax: int;
    mutable hp: int;
}

type display = {
    io: Btio.io;
    mutable title: string;
    mutable author: string;
    game: game;

    msgMapSplit: int * int;
    playerAttr: player_attributes;
    msgs: Btmessages.messageField;
}

let getTitle display = display.title
let setTitle display title = display.title <- title

let getAuthor display = display.author
let setAuthor display author = display.author <- author



let gameToIoColor x =
    if x = Btgame.color_black then Btio.color_black
    else if x = Btgame.color_red then Btio.color_red
    else if x = Btgame.color_green then Btio.color_green
    else if x = Btgame.color_yellow then Btio.color_yellow
    else if x = Btgame.color_blue then Btio.color_blue
    else if x = Btgame.color_magenta then Btio.color_magenta
    else if x = Btgame.color_cyan then Btio.color_cyan
    else Btio.color_white

let init game = {
    io = Btio.init ();
    title = "/\\\\ Bermuda Triangle //\\";
    author = "author";
    msgMapSplit = (3, 4);
    playerAttr = {
        name = "Mike";
        hpMax = 100;
        hp = 100;
    };
    game = game;
    msgs = Btmessages.newMessageField ();
}

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
        let msg = Btmessages.newMessage () in
        Btmessages.addWordsToMessage msg
            ((Btgame.Actor.getName actor) ^ ":")
            (gameToIoColor (Btgame.Actor.getColor actor)) Btio.color_black;
        Btmessages.addWordsToMessage msg text Btio.color_green
                                        Btio.color_black;
        Btmessages.addMessageToField d.msgs msg
    );

    (* If any action happens (just text output) *)
    Btgame.registerActionListener game (fun text ->
        let msg = Btmessages.newMessage () in
        Btmessages.addWordsToMessage msg text Btio.color_white
                                              Btio.color_black;
        Btmessages.addMessageToField d.msgs msg
    );

    Btgame.setMap game (Btgame.Map.newMap 100 100);
    Btgame.Map.setAscii (Btgame.Map.fieldAt (Btgame.getMap game) 2 2) 'G';
    Btgame.Map.setFg (Btgame.Map.fieldAt (Btgame.getMap game) 3 3)
                                         Btgame.color_blue;
    Btgame.Map.setBg (Btgame.Map.fieldAt (Btgame.getMap game) 5 3)
                                         Btgame.color_blue;
    Btgame.Map.setWalkable (Btgame.Map.fieldAt (Btgame.getMap game) 2 2) false;
    Btgame.Map.setWalkable (Btgame.Map.fieldAt (Btgame.getMap game) 5 3) false;

    for i = 0 to 10 do
        begin
            Btgame.Map.setAscii (Btgame.Map.fieldAt
                                    (Btgame.getMap game) i 0) ' ';
            Btgame.Map.setAscii (Btgame.Map.fieldAt
                                    (Btgame.getMap game) 0 i) ' ';
        end
    done;

    (* Some basic setup *)
    setTitle d "| Story of Lalala |";
    setAuthor d "neosam";

    (* Do some action to test the engine*)
    action game



let quit display = Btio.stop display.io


let drawMap display x y w h =
    let map = Btgame.getMap display.game in
    let (focusX, focusY) = Btgame.Map.getFocus map in
    for my_ = 0 to h - 1 do
        for mx_ = 0 to w - 1 do
            let mx = focusX + mx_ - (w / 2)
            and my = focusY + my_ - (h / 2) in
            let field = Btgame.Map.fieldAt map mx my in
            Btio.printCharC display.io
                (Btgame.Map.getAscii field) (x + mx_) (y + my_)
                (gameToIoColor (Btgame.Map.getFg field))
                (gameToIoColor (Btgame.Map.getBg field))
        done
    done

let drawActor display x y w h =
    let actorList = Btgame.getActorList display.game in
    let map = Btgame.getMap display.game in
    let (focusX, focusY) = Btgame.Map.getFocus map in
    let rec aux = function
    | [] -> ()
    | actor :: t ->
        begin
            let (px,py) = Btgame.Actor.getPos actor in
            let (finalX, finalY) = (px - focusX + (w / 2),
                                    py - focusY + (h / 2)) in
            if (finalX >= 0) && (finalY >= 0) &&
                        (finalX < w) && (finalY < h) then
                let (posX, posY) = (finalX + x, finalY + y) in
                Btio.printCharC display.io
                    (Btgame.Actor.getAscii actor)
                    posX posY
                    (gameToIoColor (Btgame.Actor.getFg actor))
                    (gameToIoColor (Btgame.Actor.getBg actor));
            aux t;
            else aux t;
        end
    in aux actorList


let drawBasicDecoration display width height =
    let io = display.io
    and (splitA, splitB) = display.msgMapSplit in
    let mapX = width * splitA / splitB in
    Btio.box io;
    Btio.vline io mapX 4 (height - 6);
    Btio.printStringC io "Messages:" 2 4
            Btio.color_white Btio.color_black;
    Btio.printStringC io "Map:" (mapX + 2) 4
            Btio.color_white Btio.color_black


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

let drawStatus display =
    Btio.printStringC display.io
            "State:" 2 2 Btio.color_white Btio.color_black



let drawFrame display =
    let io = display.io in
    let (width, height) = Btio.size io
    and (splitA, splitB) = display.msgMapSplit in
    Btio.clear io;
    drawBasicDecoration display width height;
    drawTitle display width;
    drawAuthor display width height;
    drawStatus display;
    Btmessages.draw io display.msgs 2 5 (width * splitA / splitB - 4)
                                        (height - 7) |> ignore;
    drawMap display (width * splitA / splitB + 2) 5
                        (width - width * splitA / splitB - 4) (height - 7);
    drawActor display (width * splitA / splitB + 2) 5
                        (width - width * splitA / splitB - 4) (height - 7);
    Btio.refresh io


let handleInput display =
    let key = Btio.getKey display.io in
    if key = Btio.key_q then Btgame.quit display.game
    else if key = Btio.key_h then (Btgame.goLeft display.game |> ignore; ())
    else if key = Btio.key_j then (Btgame.goDown display.game |> ignore; ())
    else if key = Btio.key_k then (Btgame.goUp display.game |> ignore; ())
    else if key = Btio.key_l then (Btgame.goRight display.game |> ignore; ())


let doFrame display =
    handleInput display;
    Btgame.step display.game


let gameloop display =
    let rec aux () =
        Thread.delay 0.1;
        doFrame display;
        drawFrame display;
        if Btgame.isDone display.game = false then aux ()
    in aux ()


type map = {
    gameMap: Btgame.gameMap
}

