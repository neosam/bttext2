open List

(* Map implementations *)
type color = int
let color_black = 0
let color_red = 1
let color_green = 2
let color_yellow = 3
let color_blue = 4
let color_magenta = 5
let color_cyan = 6
let color_white = 7






(* Actor submodule *)
module Actor = struct
    type trigger = 
        | None of unit
        | Id of string

    type actor = {
        mutable name : string;
        mutable displayColor: color;
        mutable pos : int * int;
        mutable mapChar : char;
        mutable mapFg : color;
        mutable mapBg : color;
        mutable touchAction : trigger;
    }

    type actorStorage = actor list

    let newActor () = {
        name = "unknown";
        displayColor = color_white;
        pos = (0, 0);
        mapChar = 'X';
        mapFg = color_white;
        mapBg = color_black;
        touchAction = None ();
    }

    let getName actor = actor.name
    let setName actor name = actor.name <- name
    let getColor actor = actor.displayColor
    let setColor actor color = actor.displayColor <- color
    let getPos actor = actor.pos
    let setPos actor pos = actor.pos <- pos
    let getAscii actor = actor.mapChar
    let setAscii actor ascii = actor.mapChar <- ascii
    let getFg actor = actor.mapFg
    let setFg actor c = actor.mapFg <- c
    let getBg actor = actor.mapBg
    let setBg actor c = actor.mapBg <- c

    let newActorStorage () = []
end


(* Define the Map submodule *)
module Map = struct
    type trigger = 
        | None of unit
        | Id of string

    type field = {
        mutable ascii: char;
        mutable fg: color;
        mutable bg: color;
        mutable walkable: bool;
        mutable trigger: trigger;
    }

    type gameMap = {
        width: int;
        height: int;
        fields: field list;

        mutable focus: int * int;
    }


    let newEmptyField () = {
        ascii = ' ';
        fg = color_white;
        bg = color_black;
        walkable = true;
        trigger = None ()
    }
    let newOutsideField () = 
        let f = newEmptyField () in
        begin
            f.ascii <- '.';
            f
        end

    let getAscii field = field.ascii
    let setAscii field c = field.ascii <- c
    let getFg field = field.fg
    let setFg field color = field.fg <- color
    let getBg field = field.bg
    let setBg field color = field.bg <- color
    let isWalkable field = field.walkable
    let setWalkable field value = field.walkable <- value


    let newMap width height = 
        let size = width * height in
        let rec createList lst = function
        | 0 -> lst
        | x -> createList ((newEmptyField ()) :: lst) (x - 1)
        in {
            width = width; 
            height = height; 
            fields = (createList [] size);
            focus = (0, 0);
            }

    let isOutOfBounce map x y =
        if x < 0 then true
        else if x >= map.width then true
        else if y < 0 then true
        else if y >= map.height then true
        else false
    let coordinateToIndex map x y = map.width * y + x
    let fieldAt map x y = 
        if isOutOfBounce map x y then 
            newOutsideField ()
        else
            List.nth map.fields (coordinateToIndex map x y)
    let getFocus map = map.focus
    let setFocus map focus = map.focus <- focus
end;;


(* The observer functions *)
type sayListener = (Actor.actor -> string -> unit)
type actionListener = (string -> unit)


type game = {
    mutable running: bool;
    mutable map: Map.gameMap;
    mutable actorStorage: Actor.actorStorage;
    mutable sayListener: sayListener;
    mutable actionListener: actionListener;
    mutable player: Actor.actor;
}

type gameMap = Map.gameMap


(* The main modules *)
let init () = {
    running = true;
    map = Map.newMap 1 1;
    actorStorage = Actor.newActorStorage ();
    sayListener = (fun x y -> ());
    actionListener = (fun x -> ());
    player = Actor.newActor ();
}
(** Stops the game *)
let quit game = game.running <- false

(** One game iteration *)
let step game = ()
(** Returns if the game is finished or not. *)
let isDone game = not game.running

(** Get the map. *)
let getMap game = game.map
(** Set the map. *)
let setMap game map = game.map <- map

(** Add a new actor to the game *)
let addActor game actor = game.actorStorage <- actor :: game.actorStorage

(** Get all actors from a game *)
let getActorList game = game.actorStorage

(** Set the say listener.
 * This will be executed if an actor says something.
 *)
let registerSayListener game listener = game.sayListener <- listener
(** Set the action lsitener.
 * This function will be execute if a custom action occured.
 *)
let registerActionListener game listener = game.actionListener <- listener

(** Let an actor say something 
 * This will execute the say callback.
 *)
let say game actor text =
    game.sayListener actor text
(** Apply a custom game action 
 * This will execute the action callback.
 *)
let action game text =
    game.actionListener text


(** Define an actor as player *)
let setPlayer game player = game.player <- player

(** Move an actor to a specified position.*)
let moveActor game actor (x, y) =
    let (px, py) = Actor.getPos actor in
    let finalPos = (px + x, py + y) in
    begin
        Actor.setPos actor finalPos;
        Map.setFocus game.map finalPos
    end




(** Check if a specific field is blocking
 * @return true if it is blocking, false if not.
 *)
let collisionCheckField game position =
    let (x, y) = position in
    let field = Map.fieldAt game.map x y in
    not (Map.isWalkable field)

(** Check if an actor stands on a specified field.
 * @return true if there is an actor, false if not.
 *)
let collisionCheckActor game position =
    let rec aux = function
    | [] -> false
    | actor :: t -> if Actor.getPos actor = position then true
                    else aux t
    in aux game.actorStorage


(** Check coordinate if it is a collision field.
 * @return true if collision point, false if not.
 *)
let collisionCheck game position =
    (collisionCheckActor game position) || (collisionCheckField game position)

(** Try to move an actor.
 * Checks the actor for collision.
 * It will only move the actor is it will not collide.
 * @return true, if the actor could be moved, false if it would collide
 *)
let tryMoveActor game actor movement =
    (* Extract the movement *)
    let (mx, my) = movement
    (* Extract the actor position *)
    and (ax, ay) = Actor.getPos actor in
    (* Calculate the final position *)
    let position = (mx + ax, my + ay) in
    (* Check for collision *)
    let collision = collisionCheck game position in
    (* Move the actor if possible and return if
     * the move action was successful. *)
    if collision = true then false
    else begin
        moveActor game actor movement;
        true
    end

(** Move player one field to the left *)
let goLeft game = tryMoveActor game game.player (-1, 0)
(** Move player one field to the right *)
let goRight game = tryMoveActor game game.player (1, 0)
(** Move player one field up *)
let goUp game = tryMoveActor game game.player (0, -1)
(** Move player one field bottom *)
let goDown game = tryMoveActor game game.player (0, 1)

(** Trigger type definition *)
type trigger = (game -> unit)
