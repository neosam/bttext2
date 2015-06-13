open Btrender
open Btio

type field = Stringfield of string * string
           | Intfield of string * int

type btrender = Btrender.btrender

type btdisplay = {
    (** We should be able to render somehting *)
    render: Btrender.btrender;

    (** Which title to display *)
    title: string;

    (** Which chapter to display *)
    chapter: string;

    (** Additional fields for the status bar *)
    fields: field list;

    (** Size of the status field *)
    status_size: int;

    (** Ratio between text field and map: (num/denom) *)
    text_map_ratio: int * int
}

(** Pack btrender methods in btdisplay methods
 * First parameter is the render function where only btrender is left
 * Second parameter is the display variable. *)
let render_packer (render_fn: btrender -> btrender)
                                (display: btdisplay): btdisplay = {
    render = render_fn display.render;
    title = display.title;
    chapter = display.chapter;
    fields = display.fields;
    status_size = display.status_size;
    text_map_ratio = display.text_map_ratio
}


let init render_option =
    let render = match render_option with
    | None -> Btrender.init ()
    | Some render -> render in
    { render = render;
      title = "";
      chapter = "";
      fields = [];
      status_size = 1;
      text_map_ratio = (3, 4)
    }

let quit display =
    render_packer Btrender.quit display

let add_string_field fieldName value display = display
let add_int_field fieldName value display = display
let set_string_field fieldName value display = display
let set_int_field fieldName value display = display

let clear_fields display = display

let set_title title display = {
    render = display.render;
    title = title;
    chapter = display.chapter;
    fields = display.fields;
    status_size = display.status_size;
    text_map_ratio = display.text_map_ratio
}
let get_title display = display.title

let set_chapter chapter display = {
    render = display.render;
    title = display.title;
    chapter = chapter;
    fields = display.fields;
    status_size = display.status_size;
    text_map_ratio = display.text_map_ratio
}
let get_chapter display = display.chapter


let get_render_defaults display =
    let default_foreground = (Btio.color_white, Btio.color_black)
    and (width, height) = Btrender.size display.render in
    (default_foreground, width, height)

let set_status_size status_size display = {
    render = display.render;
    title = display.title;
    chapter = display.chapter;
    fields = display.fields;
    status_size = status_size;
    text_map_ratio = display.text_map_ratio
}
let get_status_size display = display.status_size

let set_text_map_ratio text_map_ratio display = {
    render = display.render;
    title = display.title;
    chapter = display.chapter;
    fields = display.fields;
    status_size = display.status_size;
    text_map_ratio = text_map_ratio
}
let get_text_map_ratio display = display.text_map_ratio




let render_outer_box (_, _, _) (display: btdisplay): btdisplay =
    render_packer Btrender.box display
let render_title (fg, width, height) (display: btdisplay): btdisplay =
    render_packer
        (Btrender.print_string_center (Some fg) display.title (width / 2, 0))
        display
let render_chapter (fg, width, height) (display: btdisplay): btdisplay =
    render_packer
        (Btrender.print_string_right (Some fg) display.chapter (width - 2,
                                                           height - 1))
        display


let render_frame display =
    let defaults = get_render_defaults display in
    display |>
    render_outer_box defaults |>
    render_title defaults |>
    render_chapter defaults


