type game = {
	mutable running: bool;
}

let init () = {running = true}
let quit game = game.running <- false

let step game = ()
let isDone game = not game.running