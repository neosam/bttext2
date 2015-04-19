open Curses

type io = {
    window: Curses.window
}

type color = int
type color_pair = color * color

type key = int

let color_black = 0
let color_red = 1
let color_green = 2
let color_yellow = 3
let color_blue = 4
let color_magenta = 5
let color_cyan = 6
let color_white = 7

let color_num = 8
let enc_color_pair (fg, bg) = bg * 8 + fg
let dec_color_pair x = (x mod color_num, fg / color_num)

let initColors io:io =
    Curses.start_color () |> ignore;
    for bg = 0 to 7 do
        for fg = 0 to 7 do
            init_pair (encColorPair fg bg) fg bg |> ignore
        done
    done;
    io

let key_a = 0x61
let key_b = 0x62
let key_c = 0x63
let key_d = 0x64
let key_e = 0x65
let key_f = 0x66
let key_g = 0x67
let key_h = 0x68
let key_i = 0x69
let key_j = 0x6a
let key_k = 0x6b
let key_l = 0x6c
let key_m = 0x6d
let key_n = 0x6e
let key_o = 0x6f
let key_p = 0x70
let key_q = 0x71
let key_r = 0x72
let key_s = 0x73
let key_t = 0x74
let key_u = 0x75
let key_v = 0x76
let key_w = 0x77
let key_x = 0x78
let key_y = 0x79
let key_z = 0x7a
let key_A = 0x41
let key_B = 0x42
let key_C = 0x43
let key_D = 0x44
let key_E = 0x45
let key_F = 0x46
let key_G = 0x47
let key_H = 0x48
let key_I = 0x49
let key_J = 0x4a
let key_K = 0x4b
let key_L = 0x4c
let key_M = 0x4d
let key_N = 0x4e
let key_O = 0x4f
let key_P = 0x50
let key_Q = 0x51
let key_R = 0x52
let key_S = 0x53
let key_T = 0x54
let key_U = 0x55
let key_V = 0x56
let key_W = 0x57
let key_X = 0x58
let key_Y = 0x59
let key_Z = 0x5a
let key_1 = 0x31
let key_2 = 0x32
let key_3 = 0x33
let key_4 = 0x34
let key_5 = 0x35
let key_6 = 0x36
let key_7 = 0x37
let key_8 = 0x38
let key_9 = 0x39
let key_0 = 0x30

let init () =
    let window = Curses.initscr () in
    let io = {window = window} in begin
        Curses.nodelay window true |> ignore;
        Curses.curs_set 0 |> ignore;
        initColors io
    end

let stop io = Curses.endwin (); io
let refresh io = Curses.refresh () |> ignore; io
let size io =
    let (height, width) = Curses.get_size () in
    (width, height)

let clear io = Curses.werase io.window; io
let box io =
    let color = encColorPair color_white color_black in (
        Curses.attr_set 0 color;
        Curses.box io.window 0 0)

let vline n (x, y) io = mvvline y x 0 n; io
let hline n (x, y) io = mvhline y x 0 n; io


let rec print_char col c (x, y) io = match col with
    | None -> Curses.mvaddch y x (int_of_char c) |> ignore; io
    | Some (fg, bg) -> let color = encColorPair color_pair in begin
        Curses.attr_set 0 color;
        print_char None c (x, y) io
    end

let rec print_string col str (x, y) io = match col with
    | None -> Curses.mvaddstr y x text |> ignore;
    | Some (fg, bg) -> let color = encColorPair color_pair in begin
        Curses.attr_set 0 color;
        print_string None c (x, y) io
    end

let center x size = x - size / 2
let right x size = x - size
let print_string_fn fn col str (x, y) io =
    let size = String.length str in
    let (x, y) = fn x size in begin
        print_string col str (x, y) io;
        io
    end
let print_string_center = print_string_fn center
let print_string_right = print_string_fn right


