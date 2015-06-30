open Btio
open Btdisplay
open Btmap
open Quadtree

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

let default_field = Btmap.create_field
                        '.'
                        (color_white, color_black)
                        true
                        None
let null_field = Btmap.create_field
                        'X'
                        (color_red, color_black)
                        false
                        None
let persistence_map =
    Quadtree.create_persistence_map (1000, 1000)
                                    default_field null_field ()
                                    7 "testmap_"

let main () =
    let render = Btrender.init () in
    Btdisplay.init (Some render) |>
    Btdisplay.set_title "| Test |" |>
    Btdisplay.set_chapter "| Chapter |" |>
(*    Btdisplay.set_text_map_ratio (1, 2) |> *)
    Btdisplay.set_quadtree_map persistence_map |>
    Btdisplay.add_field ("Mana", "100/100") |>
    Btdisplay.add_field ("Health", "100/100") |>
    flood_messages 10 |>
    flood_messages 20 |>
    render_frame |>
    wait_for_escape render |>
    Btdisplay.quit;;

main ()
