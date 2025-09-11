----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/06/2025 08:39:25 AM
-- Design Name: 
-- Module Name: Shifter - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Shifter is
generic (
    WIDTH : integer := 32
  );
  port (
    A_in, B_in : in  std_logic_vector(WIDTH-1 downto 0);
    op : in std_logic_vector(3 downto 0);
    Output : out std_logic_vector(WIDTH-1 downto 0);
    Nout, Zout, Cout, Vout : out std_logic
  );
end Shifter;

architecture Behavioral of Shifter is
    signal shiftb: std_logic_vector(4 downto 0);
    signal temp: std_logic_vector(WIDTH-1 downto 0);
begin
    shiftb <= B_in(11 downto 7);
    shifterr: process(op)
    variable sh_am: natural range 0 to 32;
    variable A_s: signed(WIDTH-1 downto 0);
    variable A_u: unsigned(WIDTH-1 downto 0);    
    begin
        sh_am:= to_integer(unsigned(shiftb));
        A_s := signed(A_in);
        A_u := unsigned(A_in); 
    
        if (op = "1000") or (op = "1100")  then --lsl
            Output <= std_logic_vector(shift_left(A_u,sh_am)); 
        elsif (op = "1001") or (op = "1101")  then --lsr
            Output <= std_logic_vector(shift_right(A_u,sh_am));
        elsif (op = "1010") or (op = "1110") then --asr
            Output <= std_logic_vector(shift_left(A_s,sh_am));
        elsif (op = "1011") or (op = "1111") then --rotate r
            Output <= std_logic_vector(rotate_right(A_s,sh_am));
        else 
            Output <= (others => '0'); -- default
        end if;           
    --flags 
     Nout <= '0';
     Zout <= '0';
     Cout <= '0';
     Vout <= '0';
    end process;

end Behavioral;
