open Curses
open Log

(* Structure which holds the important data *)
type io = {
    window: Curses.window
}


type key = int

(* Some color difinition *)
type color = int
let color_black = 0
let color_red = 1
let color_green = 2
let color_yellow = 3
let color_blue = 4
let color_magenta = 5
let color_cyan = 6
let color_white = 7

let encColorPair (fg, bg) = bg * 8 + fg
let decColorPair x = (x mod 8, x / 8)

let initColors () =
    Curses.start_color () |> ignore;
    for bg = 0 to 7 do
        for fg = 0 to 7 do
            init_pair (encColorPair fg bg) fg bg |> ignore
        done
    done

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



(* Initialize the system *)
let init () =
    Log.debug "%s" "Init BTIO";
    let window = Curses.initscr () in (
    Curses.nodelay window true |> ignore;
    Curses.curs_set 0 |> ignore;
    initColors ();
    {window = window})

(* Stop the system *)
let stop io = Curses.endwin (); Log.debug "%s" "Stop BTIO"

(* Clear the window *)
let clear io = Curses.werase io.window; ()

(* Paint the new content *)
let refresh io = Curses.refresh () |> ignore; ()

(* Revert the size,
    to have width at first parameter and height as second *)
let size io =
    let (height, width) = Curses.get_size () in
    (width, height)


let box io =
    let color = encColorPair color_white color_black in (
    Curses.attr_set 0 color;
    Curses.box io.window 0 0)

let vline io (x, y) n = mvvline y x 0 n

let printChar io c (x, y) = Curses.mvaddch y x (int_of_char c) |> ignore; ()

let printCharC io c pos color_pair  =
    let color = encColorPair color_pair in (
    Curses.attr_set 0 color;
    printChar io c pos)

let printString io text (x, y) =
    Curses.mvaddstr y x text |> ignore;
    ()

let printStringC io text (x, y) (fg, bg) =
    let color = encColorPair fg bg in (
    Curses.attr_set 0 color;
    printString io text x y)

let printStringCenterC io text x y fg bg =
    let x = x - String.length text / 2 in
    printStringC io text x y fg bg

let printStringRightC io text x y fg bg =
    let x = x - String.length text in
    printStringC io text x y fg bg

let colorPairs () = Curses.color_pairs ()


let getKey io = Curses.getch ()
