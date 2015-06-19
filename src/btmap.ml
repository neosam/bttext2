open Btio
open Btrender

type btfield = {
    c: char;
    color: Btio.color_pair;
    walkable: bool;
    trigger: string option
}

type 'a four_tuple =
    'a * 'a * 'a * 'a

type map_tree =
    | Field of btfield
    | Node of map_tree four_tuple

type node = map_tree four_tuple


type btmap = {
    size: int * int;
    depth: int;
    root: map_tree;
    default_field: btfield
}

(* --- Basic field functions *)
let create_field c color walkable trigger = {
    color = color;
    c = c;
    walkable = walkable;
    trigger = trigger
}

let set_char c field = { field with c = c }
let get_char field = field.c
let set_color color field = { field with color = color }
let get_color field = field.color




let initiate_map_tree (default_field: btfield) depth =
    let rec aux = function
        | 0 -> (Field default_field)
        | n -> let sub = aux (n - 1) in
                (Node (sub, sub, sub, sub)) in
    aux depth

let node_top_left (node: node) =
    let (x, _, _, _) = node in x
let node_top_right (node: node) =
    let (_, x, _, _) = node in x
let node_botom_left (node: node) =
    let (_, _, x, _) = node in x
let node_bottom_right (node: node) =
    let (_, _, _, x) = node in x

let set_top_left sub_node (_, top_right, bottom_left, bottom_right) =
    (sub_node, top_right, bottom_left, bottom_right)
let set_top_right sub_node (top_left, _, bottom_left, bottom_right) =
    (top_left, sub_node, bottom_left, bottom_right)
let set_bottom_left sub_node (top_left, top_right, _, bottom_right) =
    (top_left, top_right, sub_node, bottom_right)
let set_bottom_right sub_node (top_left, top_right, bottom_left, _) =
    (top_left, top_right, bottom_left, sub_node)



let depth_from_size size =
    let float_size = float_of_int size in
    int_of_float ((log float_size) /. (log 2.0))

let create_map (width, height) default_field =
    let min_dimension = min width height in 
    let depth = depth_from_size min_dimension in
    let root = initiate_map_tree default_field depth in {
        size = (width, height);
        depth = depth;
        root = root;
        default_field = default_field
    }

let set_root root map = { map with root = root }


let bounds_check (x, y) map =
    let (width, height) = map.size in
    x >= 0 && x < width && y >= 0 && y < height

let rec get_field_of_node node map = match node with
    | Field field -> field
    | Node _ -> map.default_field

let get_sub_node (x, y) size = function
    | Field field -> (Field field, (0, 0), 0)
    | Node (top_left, top_right, bottom_left, bottom_right) ->
            let new_pos = (x mod 2, y mod 2)
            and new_size = size / 2 in
            let sub_node = if x < new_size && y < new_size then top_left
                else if x >= new_size && y < new_size then top_right
                else if x < new_size && y >= new_size then bottom_left
                else bottom_right in
            (sub_node, new_pos, new_size)

(* don't know the pow function *)
let rec pow x y =
    let even = (y mod 2) = 0 in
    if even then
        let tmp = pow x (y / 2) in tmp * tmp
    else x * pow x (y - 1)

let field_at pos map =
    let size = pow 2 map.depth in
    let rec aux pos size node = function
        | 0 -> get_field_of_node node map
        | depth -> let (sub_node, sub_pos, sub_size) =
                                            get_sub_node pos size node in
            aux sub_pos sub_size node (depth - 1) in
    aux pos size map.root map.depth


let set_field pos field map =
    let size = pow 2 map.depth in
    let rec aux (x, y) size = function
        | Field field -> (Field field)
        | Node node ->
                let (top_left, top_right, bottom_left, bottom_right) = node
                and new_pos = (x mod 2, y mod 2)
                and new_size = size / 2 in
                let (set_fn, sub_node) =
                    if x < new_size && y < new_size then 
                        (set_top_left, top_left)
                    else if x >= new_size && y < new_size then 
                        (set_top_right, top_right)
                    else if x < new_size && y >= new_size then 
                        (set_bottom_left, bottom_left)
                    else (set_bottom_right, bottom_right) in
                Node (set_fn (aux new_pos new_size sub_node) node) in
    set_root (aux pos size map.root) map

