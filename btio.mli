type io

type color
val color_black : color
val color_red : color
val color_green : color
val color_yellow : color
val color_blue : color
val color_magenta : color
val color_cyan : color
val color_white : color

type key
val key_a : key
val key_b : key
val key_c : key
val key_d : key
val key_e : key
val key_f : key
val key_g : key
val key_h : key
val key_i : key
val key_j : key
val key_k : key
val key_l : key
val key_m : key
val key_n : key
val key_o : key
val key_p : key
val key_q : key
val key_r : key
val key_s : key
val key_t : key
val key_u : key
val key_v : key
val key_w : key
val key_x : key
val key_y : key
val key_z : key
val key_A : key
val key_B : key
val key_C : key
val key_D : key
val key_E : key
val key_F : key
val key_G : key
val key_H : key
val key_I : key
val key_J : key
val key_K : key
val key_L : key
val key_M : key
val key_N : key
val key_O : key
val key_P : key
val key_Q : key
val key_R : key
val key_S : key
val key_T : key
val key_U : key
val key_V : key
val key_W : key
val key_X : key
val key_Y : key
val key_Z : key
val key_1 : key
val key_2 : key
val key_3 : key
val key_4 : key
val key_5 : key
val key_6 : key
val key_7 : key
val key_8 : key
val key_9 : key
val key_0 : key



val init : unit -> io
val stop : io -> unit
val clear : io -> unit
val refresh : io -> unit
val size : io -> int * int

val box : io -> unit
val vline : io -> int -> int -> int -> unit
val printString : io -> string -> int -> int -> unit
val printStringC : io -> string -> int -> int -> color -> color -> unit
val printStringCenterC : io -> string -> int -> int -> color -> color -> unit
val printStringRightC : io -> string -> int -> int -> color -> color -> unit

val colorPairs : unit -> int
val getKey : io -> key