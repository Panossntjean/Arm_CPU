----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/08/2025 08:50:05 PM
-- Design Name: 
-- Module Name: INC4 - Behavioral
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

entity INC4 is
    Port ( PC : in STD_LOGIC_VECTOR (31 downto 0);
           PCPlus4 : out STD_LOGIC_VECTOR (31 downto 0));
end INC4;

architecture Behavioral of INC4 is
begin
--PC <= "";
process(PC)
begin
 PCPlus4 <= std_logic_vector(unsigned(PC)+4);
end process;
end Behavioral;
