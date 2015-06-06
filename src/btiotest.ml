open Btio

let rec wait_for_escape io =
    let key = Btio.get_key io in
    if key = Btio.key_q then io
    else wait_for_escape io

let main () =
    Btio.init () |>
    Btio.box |>
    Btio.hline 5 (2, 2) |>
    Btio.vline 5 (3, 3) |>
    Btio.print_string None "Asdf" (1, 4) |>
    wait_for_escape |>
    Btio.quit;;

main ();;
