library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--use ieee.std_logic_arith.all;
library work;
use work.mult_3x3_pack.all;

entity matrix is
    port(clk              : in std_logic; 
            reset          : in std_logic;
            data_in_1  : in std_logic_vector(7 downto 0);
            data_in_2  : in std_logic_vector(7 downto 0);
            out_matrix : out t_2d_array16;
            matrix_ready : out std_logic
            );
end matrix;

architecture Behavioral of matrix is
signal count : unsigned(3 downto 0) := (others => '0');
signal matrix_fulled : std_logic := '0';
signal to_use_matrix_1 : t_2d_array;
signal to_use_matrix_2 : t_2d_array;
signal  temp_temp_out : t_2d_array16;

type ram_type is array (0 to 8) of std_logic_vector(3 downto 0); 

signal program : ram_type := (
"0000",
"0001",
"0100",
"0010", 
"0101",
"1000",
"0110", 
"1001", 
"1010");
begin
    GenerateLabel : for i in 0 to 2 generate
        to_use_matrix_1(i)(0) <= "00000000";
        to_use_matrix_1(i)(1) <= "00000000";
        to_use_matrix_1(i)(2) <= "00000000";
        to_use_matrix_2(i)(0) <= "00000000";
        to_use_matrix_2(i)(1) <= "00000000";
        to_use_matrix_2(i)(2) <= "00000000";
    end generate;
    process(clk,reset)
        variable  temp_matrix1 : t_2d_array;
        variable  temp_matrix2 : t_2d_array;
        variable  temp_out : t_2d_array16;
        
        variable  ii,jj : std_logic_vector(1 downto 0); 
        
    begin
        if(reset = '1') then
            for i in 0 to 2 loop
                for j in 0 to 2 loop
                    temp_matrix1(i)(j) := "00000000";
                    temp_matrix2(i)(j) := "00000000";
                    temp_out(i)(j) := "0000000000000000";
                end loop;
            end loop;
            count <= (others => '0');
            matrix_ready <= '0';
        elsif(rising_edge(clk)) then
            if(count < 9) then
                ii := program(TO_INTEGER(count))(3 downto 2);
                jj := program(TO_INTEGER(count))(1 downto 0);
                temp_matrix1(TO_INTEGER(unsigned(ii)))(TO_INTEGER(unsigned(jj))) := data_in_1;
                temp_matrix2(TO_INTEGER(unsigned(jj)))(TO_INTEGER(unsigned(ii))) := data_in_2;
                

            end if;
            count <= count + 1; 
            if(count = 9) then 
--                count <= (others => '0');
                for i in 0 to 2 loop
                    for j in 0 to 2 loop
                        to_use_matrix_1(i)(j) <= temp_matrix1(i)(j);
                        to_use_matrix_2(i)(j) <= temp_matrix2(i)(j);
                    end loop;
                end loop;
                matrix_fulled <= '1';
            end if;
            if(matrix_fulled = '1') then
                for i in 0 to 2 loop
                   for j in 0 to 2 loop
                      for k in 0 to 2 loop
                         temp_out(i)(j) := std_logic_vector(
                                                           signed(temp_out(i)(j)) +
                                                            (signed(to_use_matrix_1(i)(k)) * signed(to_use_matrix_2(k)(j))));
                       end loop;
                   end loop;
                end loop;
                for i in 0 to 2 loop
                    for j in 0 to 2 loop
                        out_matrix(i)(j) <= temp_out(i)(j);
                    end loop;
                end loop;
--                temp_temp_out <= temp_out;
                matrix_ready <= '1';
            end if; 
        end if; 
    end process;    
    
--    out_matrix<= temp_temp_out;
--    process(matrix_fulled)
--    variable  temp_out : t_2d_array16;
--    begin
--            for i in 0 to 2 loop
--                for j in 0 to 2 loop
--                    temp_out(i)(j) := "0000000000000000";
--                end loop;
--            end loop;
--        for i in 0 to 2 loop
--           for j in 0 to 2 loop
--              for k in 0 to 2 loop
--                 temp_out(i)(j) := std_logic_vector(
--                                                   signed(temp_out(i)(j)) +
--                                                    (signed(to_use_matrix_1(i)(k)) * signed(to_use_matrix_2(k)(j))));
--               end loop;
--           end loop;
--       end loop;
--       out_matrix <= temp_out;
--       matrix_ready <= '1';
--    end process;



end Behavioral;
