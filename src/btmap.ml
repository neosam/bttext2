open Btio
open Btrender
open Quadtree

type btfield = {
    c: char;
    color: Btio.color_pair;
    walkable: bool;
    trigger: string option
}

type 'a pair = 'a * 'a

type btmap = {
    render: Btrender.btrender;
    map: (btfield, unit) Quadtree.map;
    pos: int pair;
    size: int pair
}


(* --- Basic field functions *)
let create_field c color walkable (trigger: string option) = {
    color = color;
    c = c;
    walkable = walkable;
    trigger = trigger
}

let set_char c field = { field with c = c }
let get_char field = field.c
let set_color color field = { field with color = color }
let get_color field = field.color


let create_map pos size render = 
    let (default_field: btfield) = (create_field
                                                 'X'
                                                 (color_white, color_black)
                                                 true
                                                 None) in {
    render = render;
    map = Quadtree.create_node_map (1, 1) default_field ();
    pos = pos;
    size = size
}
let set_map (map: (btfield, unit) Quadtree.map) (btmap: btmap) = { btmap with
    map = map
}

let set_render render map = { map with render = render }

let field_at (pos: int pair) (map: btmap) =
    Quadtree.field_at pos map.map
let set_field (pos: int pair) (field: btfield) (map: btmap) =
    set_map (Quadtree.set_field pos field map.map) map

let render_hull (render_fn: btrender -> btrender) (map: btmap) =
    set_render (render_fn map.render) map



let render_line (map: btmap) (line: int) =
    let (screen_x, screen_origin_y) = map.pos in
    let screen_y = screen_origin_y + line
    and (line_length, _) = map.size
    and (map_x, map_origin_y) = (-5, -5) in
    let map_y = map_origin_y + line in
    let rec aux column map_acc field_list = match field_list with
    | [] -> map_acc
    | field :: t->
            let (new_map: btmap) = render_hull (Btrender.print_string
                                (Some field.color)
                                (Char.escaped field.c)
                                (column, screen_y)) map_acc in
            aux (column + 1) new_map t in
    aux screen_x map (Quadtree.map_get_line (map_x, map_y)
                                            line_length
                                            map.map)

let render map =
    let (_, height) = map.size in
    let rec aux map_acc line = match line with
    | 0 -> render_line map_acc line
    | _ ->
            let map_new = render_line map_acc line in
            aux map_new (line - 1) in
    aux map (height - 1)
