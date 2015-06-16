open Str
open Btio
open Btrender

type textblock = Btio.color_pair * string
type line = textblock list

type bttextfield = {
    render: btrender;
    pos: int * int;
    size: int * int;
    lines: line list
}


(* --- Basic default functions *)
let create pos size render = {
    render = render;
    pos = pos;
    size = size;
    lines = []
}

let resize size textfield = {
    render = textfield.render;
    pos = textfield.pos;
    size = size;
    lines = textfield.lines
}

let get_btrender textfield = textfield.render

let set_render render textfield: bttextfield = {
    render = render;
    pos = textfield.pos;
    size = textfield.size;
    lines = textfield.lines
}


(* --- Textblock functions *)
let create_textblock text color_pair = (color_pair, text)
let textblock_size (_, text) = String.length text


(* --- Lowlevel functions *)
let set_lines (lines: line list) textfield: bttextfield = {
    render = textfield.render;
    pos = textfield.pos;
    size = textfield.size;
    lines = lines
}
let get_last_line textfield: line = match textfield.lines with
    | [] -> []
    | line :: _ -> line
let get_tail textfield: line list = match textfield.lines with
    | [] -> []
    | _ :: t -> t
let add_textblock_to_line block line: line = line @ [block]
let add_textblock block textfield =
    let last_line = get_last_line textfield
    and tail = get_tail textfield in
    let new_last_line = add_textblock_to_line block last_line in
    set_lines (new_last_line :: tail) textfield

let add_newline textfield =
    set_lines ([] :: textfield.lines) textfield

let line_size (line: line) =
    let rec aux acc = function
        | [] -> acc
        | block :: t ->
                let blocksize = textblock_size block in
                let newsize = blocksize + acc in
                aux newsize t in
    aux 0 line


(* --- Midlevel functions *)
let check_for_linebreak line block textfield: bool =
    let (width, _) = textfield.size in
    (line_size line) + (textblock_size block) >= width
let add_textblock_safely block textfield =
    let last_line = get_last_line textfield in
    let need_newline = check_for_linebreak last_line block textfield in (
    if need_newline then add_newline textfield
    else textfield) |>
    add_textblock block

let add_textblocks block_list textfield =
    let aux textfield_acc = function
        | [] -> textfield
        | block :: t -> add_textblock_safely block textfield in
    aux textfield block_list


(* --- Highlevel functions *)
let separator = Str.regexp "\\w"
let string_to_blocks color text: textblock list =
    let words = Str.split separator text in
    List.map (fun word -> create_textblock word color) words
let add_string color text textfield =
    let block_list = string_to_blocks color text in
    add_textblocks block_list textfield



(* --- Rendering *)
let textfield_render_hull render_fn textfield: bttextfield =
    set_render (render_fn textfield.render) textfield

let render_token (color, text) (x, y) textfield: bttextfield =
    textfield_render_hull (
        Btrender.print_string (Some color) text (x, y)) textfield

let render_line line (start_x, y) textfield: bttextfield =
    let rec aux x textfield_acc = function
        | [] -> textfield_acc
        | block :: t ->
                let new_x = x + (textblock_size block)
                and new_textfield = render_token block (x, y) textfield_acc in
                aux new_x new_textfield t in
    aux start_x textfield line

let do_render start_top start_bottom (textfield: bttextfield) =
    let height = start_bottom - start_top
    and (x, _) = textfield.pos in
    let rec aux i (textfield_acc: bttextfield) = function
        | [] -> textfield_acc
        | line :: t ->
                if i > height then textfield_acc
                else 
                    let new_textfield = render_line line
                                        (x, start_bottom - i) textfield in
                    aux (i + 1) new_textfield t in
    aux 0 textfield textfield.lines

let render textfield =
    let (x, y) = textfield.pos
    and (width, height) = textfield.size in
    let internal_height = min (List.length textfield.lines) height in
    do_render y (y + internal_height) textfield
