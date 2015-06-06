open Btio
open Btrender

let rec wait_for_escape render =
    let io = Btrender.unpack_io render in
    let key = Btio.get_key io in
    if key = Btio.key_q then render
    else wait_for_escape (Btrender.pack_io io render)

let main () =
    Btrender.init () |>
    Btrender.box |>
    Btrender.hline 5 (2, 2) |>
    Btrender.vline 5 (3, 3) |>
    Btrender.print_string None "Asdf" (1, 4) |>
    wait_for_escape |>
    Btrender.quit;;

main ();;
