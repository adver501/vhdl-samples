library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.mult_3x3_pack.all;

entity matrix_tb is
end matrix_tb;

architecture tb of matrix_tb is
    COMPONENT matrix
    port(clk              : in std_logic; 
            reset          : in std_logic;
            data_in_1  : in std_logic_vector(7 downto 0);
            data_in_2  : in std_logic_vector(7 downto 0);
            out_matrix : out t_2d_array16;
            matrix_ready : out std_logic
            );
    END COMPONENT;
    signal clk : std_logic := '0';
    signal reset : std_logic := '0';
    
   signal a : std_logic_vector(7 downto 0) := "00000000";
   signal b : std_logic_vector(7 downto 0) := "00000000";
   signal out_matrix : t_2d_array16;
   signal matrix_ready : std_logic;
   
   constant Clk_period : time := 10 ns;
begin
    uut: matrix PORT MAP (
          clk => clk,
          reset => reset,
          data_in_1 => a,
          data_in_2 => b,
          out_matrix => out_matrix,
          matrix_ready => matrix_ready
        );
        
   Clk_process :process
    begin
        clk <= '0';
        wait for Clk_period/2;
        clk <= '1';
        wait for Clk_period/2;
   end process;
   stim_proc: process
   begin
        reset <= '1'; 
        wait for 100 ns;
        wait until falling_edge(clk);
        reset <= '0';
        a <= std_logic_vector(to_signed(3,8));
        b <= std_logic_vector(to_signed(2,8)); wait for Clk_period;
        a <= std_logic_vector(to_signed(1,8));
        b <= std_logic_vector(to_signed(0,8)); wait for Clk_period;
        a <= std_logic_vector(to_signed(3,8));
        b <= std_logic_vector(to_signed(4,8)); wait for Clk_period;
        a <= std_logic_vector(to_signed(1,8));
        b <= std_logic_vector(to_signed(5,8)); wait for Clk_period;
        a <= std_logic_vector(to_signed(2,8));
        b <= std_logic_vector(to_signed(2,8)); wait for Clk_period;
        a <= std_logic_vector(to_signed(1,8));
        b <= std_logic_vector(to_signed(3,8)); wait for Clk_period;
        a <= std_logic_vector(to_signed(3,8));
        b <= std_logic_vector(to_signed(5,8)); wait for Clk_period;
        a <= std_logic_vector(to_signed(2,8));
        b <= std_logic_vector(to_signed(0,8)); wait for Clk_period;
        a <= std_logic_vector(to_signed(1,8));
        b <= std_logic_vector(to_signed(6,8)); wait for Clk_period;
        wait until matrix_ready = '1'; wait for Clk_period;
        reset <= '1';
        
        wait for 100 ns;
        wait;
        end process;

end tb;
