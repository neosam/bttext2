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
    render_frame |>
    wait_for_escape render |>
    Btdisplay.quit;;

main ()
