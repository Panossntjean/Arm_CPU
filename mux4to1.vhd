----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/13/2025 04:35:36 PM
-- Design Name: 
-- Module Name: mux4to1 - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mux4to1 is
generic(WIDTH : positive := 32);
    Port (
        A0: in STD_LOGIC_VECTOR(WIDTH-1 DOWNTO 0);
        A1: in STD_LOGIC_VECTOR(WIDTH-1 DOWNTO 0);
        A2: in STD_LOGIC_VECTOR(WIDTH-1 DOWNTO 0);
        A3: in STD_LOGIC_VECTOR(WIDTH-1 DOWNTO 0);
        S: in STD_LOGIC_VECTOR(1 DOWNTO 0);
        Y: out STD_LOGIC_VECTOR(WIDTH-1 DOWNTO 0));
end mux4to1;

architecture Behavioral of mux4to1 is

begin

    process (A0, A1, S)
    begin
       if (S = "00") then
          Y <= A0;
       elsif (S = "11") then 
         Y <= A1;
       elsif (S = "10") then 
         Y <= A2;
       else 
         Y <= (others=>'0');
       end if;
  end process;

end Behavioral;
