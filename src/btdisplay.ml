open Btrender
open Btio

type field = string * string

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

let replace_field_list (fields: field list)
                        (display: btdisplay): btdisplay = {
    render = display.render;
    title = display.title;
    chapter = display.chapter;
    fields = fields;
    status_size = display.status_size;
    text_map_ratio = display.text_map_ratio
    }

let add_field field display =
    replace_field_list (List.append display.fields [field]) display

let replace_field_value field field_name value =
    let (current_field_name, _) = field in
    if field_name = current_field_name then (field_name, value)
    else field
let replace_field_value_in_list field_name value fields =
    let rec aux acc = function
    | [] -> acc
    | a :: t -> aux (replace_field_value a field_name value :: acc) t in
    aux [] fields
let set_field field_name value display =
    replace_field_list (replace_field_value_in_list field_name
                            value display.fields) display


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

let draw_single_field (fg, _, _) field x y display: int * btdisplay =
    let (field_name, field_value) = field in
    let string_to_print = field_name ^ ": " ^ field_value in
    let length = String.length string_to_print in
    let new_x = x + length + 2 in
    (new_x, render_packer
        (Btrender.print_string (Some fg) string_to_print (x, y)) display)

let draw_fields defaults start_x y display =
    let rec aux current_x display_acc = function
        | [] -> display_acc
        | field :: t ->
                let (next_x, new_display) =
                    draw_single_field defaults field current_x y display in
                aux next_x new_display t in
    aux start_x display display.fields
let render_status_bar (fg, width, height) (display: btdisplay): btdisplay =
    display |>
    render_packer (fun (render: btrender) -> render |>
        Btrender.print_string (Some fg) "Status" (2, 1)
    ) |>
    draw_fields (fg, width, height) 10 1

let calculate_separator_column width display =
    let (num, denom) = display.text_map_ratio in
    width * num / denom

let render_text_and_map_decoration defaults display =
    let (fg, overall_width, overall_height) = defaults in
    let separator_column = calculate_separator_column overall_width display
    and start_height = display.status_size + 2 in
    let area_height = overall_height - start_height - 1 in
    render_packer (fun (render: btrender) -> render |>
        Btrender.print_string (Some fg) "Text:" (2, start_height) |>
        Btrender.print_string (Some fg) "Map:" (separator_column + 2,
                                                    start_height) |>
        Btrender.vline area_height (separator_column, start_height)
    ) display


let render_outer_decoration defaults display =
    display |>
    render_outer_box defaults |>
    render_title defaults |>
    render_chapter defaults

let render_content defaults display =
    display |>
    render_status_bar defaults |>
    render_text_and_map_decoration defaults

let render_frame display =
    let defaults = get_render_defaults display in
    display |>
    render_outer_decoration defaults |>
    render_content defaults
