open Btio
open Btdisplay

let rec wait_for_escape render display =
    let key = Btrender.get_key render in
    if key = Btio.key_q then display
    else wait_for_escape render display

let add_text text display =
    let color = (Btio.color_red, Btio.color_black) in
    Btdisplay.add_message color text display

let flood_messages count display =
    let rec aux display_aux = function
        | 0 -> display_aux
        | i -> let new_display = add_text (string_of_int i) display_aux in
                aux new_display (i - 1) in
    aux display count |>
    Btdisplay.add_message_newline (Btio.color_black, Btio.color_black) ""

let main () =
    let render = Btrender.init () in
    Btdisplay.init (Some render) |>
    Btdisplay.set_title "| Test |" |>
    Btdisplay.set_chapter "| Chapter |" |>
    Btdisplay.set_text_map_ratio (1, 2) |>
    Btdisplay.add_field ("Mana", "100/100") |>
    Btdisplay.add_field ("Health", "100/100") |>
    flood_messages 10 |>
    flood_messages 20 |>
    render_frame |>
    wait_for_escape render |>
    Btdisplay.quit;;

main ()
