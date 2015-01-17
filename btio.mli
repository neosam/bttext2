(** Base type for IO.
  * 
  * This type is used as the interface which
  * holds the curses window or the html data
  * needed to perform the IO operations.
  * @author Simon Goller <neosam@posteo.de>
  *)
type io


(** IO Color Type.
  * 
  * @author Simon Goller <neosam@posteo.de>
  *)
type color

(** Representation of the black color *)
val color_black : color

(** Representation of the red color *)
val color_red : color

(** Representation of the green color *)
val color_green : color

(** Representation of the yellow color *)
val color_yellow : color

(** Representation of the blue color *)
val color_blue : color

(** Representation of the magenta color *)
val color_magenta : color

(** Representation of the cyan color *)
val color_cyan : color

(** Representation of the white color *)
val color_white : color


(** Key representation *)
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



(** Initialize the terminal.
  * unit () -> io *)
val init : unit -> io

(** Shutdown terminal.
  * stop io -> () *)
val stop : io -> unit

(** Clear the terminal.
  * clear io -> () *)
val clear : io -> unit

(** Draw the new content to the terminal.
  * refresh io -> () *)
val refresh : io -> unit

(** Get terminal size.
  * size io -> (x, y) *)
val size : io -> int * int


(** Draw box around at the window edges.
  * box io -> () *)
val box : io -> unit

(** Draw a vertical line.
  * vline io x y height -> ()
  *)
val vline : io -> int -> int -> int -> unit

(** Draw the given character on the given position.
  * printChar io character x y -> () *)
val printChar : io -> char -> int -> int -> unit

(** Draw a colored character.
  * printCharC io character x y foreground background -> () *)
val printCharC : io -> char -> int -> int -> color -> color -> unit

(** Print a string ot the terminal.
  * printString io text x y -> () *)
val printString : io -> string -> int -> int -> unit

(** Print a string of the specified color.
  * printStringC io text x y foreground background -> () *)
val printStringC : io -> string -> int -> int -> color -> color -> unit

(** Print a string of the specified color at the center of the given position.
  * printStringCenterC io text x y foreground background -> () *)
val printStringCenterC : io -> string -> int -> int -> color -> color -> unit

(** Print a string of the specified color at the right of the given position.
  * printStringRightC io text x y foreground background -> () *)
val printStringRightC : io -> string -> int -> int -> color -> color -> unit


(** Get the current pressed key.
  * getKey io -> key *)
val getKey : io -> key
