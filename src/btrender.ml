open Btio

type btio = Btio.io

type btrender = {
    io: btio
}

let init () =
    let io = Btio.init () in
    { io = io }

let unpack_io render = render.io
let pack_io io render = {io = io}
let call_io_packing fn render =
    let io = unpack_io render in
    let final_io = fn io in
    pack_io final_io render

let quit render = call_io_packing Btio.quit render

let refresh render =
    render |>
    call_io_packing Btio.refresh |>
    call_io_packing Btio.clear

let size render =
    Btio.size (unpack_io render)

let box render =
    render |>
    call_io_packing Btio.box

let vline size point render =
    render |>
    call_io_packing (Btio.vline size point)

let hline size point render =
    render |>
    call_io_packing (Btio.hline size point)

let print_char color_pair_opt c pos render =
    render |>
    call_io_packing (Btio.print_char color_pair_opt c pos)

let print_string color_pair_opt str pos render =
    render |>
    call_io_packing (Btio.print_string color_pair_opt str pos)

let print_string_center color_pair_opt str pos render =
    render |>
    call_io_packing (Btio.print_string_center color_pair_opt str pos)

let print_string_right color_pair_opt str pos render =
    render |>
    call_io_packing (Btio.print_string_right color_pair_opt str pos)
