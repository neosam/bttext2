open List
open Hashtbl
open Log

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
        | ActorTriggerId of string

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
        | MapTriggerId of string

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
    let getTrigger field = field.trigger
    let setTrigger field trigger = field.trigger <- trigger


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

(** Trigger type definition *)
type 'a trigger = ('a -> unit)

(** General callback definitionn *)
type 'a callback = ('a -> unit)

type game = {
    mutable running: bool;
    mutable map: Map.gameMap;
    mutable actorStorage: Actor.actorStorage;
    mutable sayListener: sayListener;
    mutable actionListener: actionListener;
    mutable player: Actor.actor;
    trigger: (string, game trigger) Hashtbl.t;
    mutable collision: bool;
    mutable runTrigger: bool;
    mutable stepCallback: game callback list;
}

type gameMap = Map.gameMap


(* The main modules *)
let init () = begin
    Log.debug "%s" "Btgame started";
    {
        running = true;
        map = Map.newMap 1 1;
        actorStorage = Actor.newActorStorage ();
        sayListener = (fun x y -> ());
        actionListener = (fun x -> ());
        player = Actor.newActor ();
        trigger = Hashtbl.create 1000;
        collision = true;
        runTrigger = true;
        stepCallback = [];
    }
end

(** Stops the game *)
let quit game = game.running <- false; Log.debug "%s" "Btgame stopped"

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

(** Add a step callback function
  * It will be called on every step.
  *)
let addStepCallback game callback =
    game.stepCallback <- callback::game.stepCallback

(** Remove a step callback function. *)
let removeStepCallback game callback =
    game.stepCallback <-
        List.filter (fun x -> x != callback) game.stepCallback

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


(** Add new trigger *)
let addTrigger game name trigger =
    Hashtbl.add game.trigger name trigger

(** Return a trigger of the given name.
 * If there is no trigger found, an empty function
 * will be returned. *)
let getTrigger game name =
    let hasTrigger = Hashtbl.mem game.trigger name in
    if hasTrigger then Hashtbl.find game.trigger name
    else fun x -> ()


(** Run the trigger of the given field *)
let runTrigger game position =
    let (x, y) = position in
    let field = Map.fieldAt game.map x y in
    let mapTrigger = Map.getTrigger field in
    match mapTrigger with
    | Map.None _ -> ()
    | Map.MapTriggerId triggerName ->
        let trigger = getTrigger game triggerName in
        trigger game

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
    (* Calculate the final positiplayer on *)
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

(** To print debug messages from coordinates *)
let strFromIntInt (x, y) =
    (string_of_int x) ^ " " ^ (string_of_int y)

(** Returns if the player can collide or not *)
let getCollision game = game.collision
(** Set the collision state *)
let setCollision game state = game.collision <- state

let getRunTrigger game = game.runTrigger
let setRunTrigger game state = game.runTrigger <- state

(** Moves the player to the given direction if possible.
 * The directionis a vector.  The engine will add the vector to the current
 * field and check if the field is 'walkable' or if there is another actor.
 * If the field is good tto go, the player will placed on the field and
 * the function will return true.  If the players position will not be touched
 * and it will return false.
 * If collision is disabled, there will not be any collision check. *)
let tryMovePlayer game movement =
    Log.debug "%s %s" "Player move event to " (strFromIntInt movement);
    (* Extract the movement *)
    let (mx, my) = movement
    (* Extract the actor position *)
    and (ax, ay) = Actor.getPos game.player in
    (* Calculate the final position *)
    let position = (mx + ax, my + ay) in
    begin
        if (getRunTrigger game) then
            runTrigger game position;
        if (getCollision game) then
            tryMoveActor game game.player movement
        else begin
            moveActor game game.player movement;
            (* We have never a collision, so we return always true here *)
            true
        end
    end

(** Move player one field to the left *)
let goLeft game = tryMovePlayer game (-1, 0)
(** Move player one field to the right *)
let goRight game = tryMovePlayer game (1, 0)
(** Move player one field up *)
let goUp game = tryMovePlayer game (0, -1)
(** Move player one field bottom *)
let goDown game = tryMovePlayer game (0, 1)
