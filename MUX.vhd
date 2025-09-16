----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/08/2025 08:47:13 PM
-- Design Name: 
-- Module Name: MUX - Behavioral
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

entity MUX is
generic(WIDTH : positive := 4);
port (
    A0: in STD_LOGIC_VECTOR(WIDTH-1 DOWNTO 0);
    A1: in STD_LOGIC_VECTOR(WIDTH-1 DOWNTO 0);
    S: in STD_LOGIC;
    Y: out STD_LOGIC_VECTOR(WIDTH-1 DOWNTO 0));

end MUX;

architecture Behavioral of MUX is

begin
  process (A0, A1, S)
    begin
    if (S = '0') then
        Y <= A0;
    else
        Y <= A1;
    end if;
  end process;

end Behavioral;
