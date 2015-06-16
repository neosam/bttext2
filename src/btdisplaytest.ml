open Btio
open Btdisplay

let rec wait_for_escape render display =
    let key = Btrender.get_key render in
    if key = Btio.key_q then display
    else wait_for_escape render display

let main () =
    let render = Btrender.init () in
    Btdisplay.init (Some render) |>
    Btdisplay.set_title "| Test |" |>
    Btdisplay.set_chapter "| Chapter |" |>
    Btdisplay.set_text_map_ratio (1, 2) |>
    Btdisplay.add_field ("Mana", "100/100") |>
    Btdisplay.add_field ("Health", "100/100") |>
    Btdisplay.add_message (Btio.color_red, Btio.color_black) "Hello World" |>
    render_frame |>
    wait_for_escape render |>
    Btdisplay.quit;;

main ()
