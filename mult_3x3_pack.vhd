library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

package mult_3x3_pack is
    
    type t_1d_array is array(integer range 0 to 2) of std_logic_vector(7 downto 0);
    type t_1d_array16 is array(integer range 0 to 2) of std_logic_vector(15 downto 0);

    type t_2d_array is array(integer range 0 to 2) of t_1d_array;

    type t_2d_array16 is array(integer range 0 to 2) of t_1d_array16;
	
end mult_3x3_pack;
