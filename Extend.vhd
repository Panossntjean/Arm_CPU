----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/09/2025 12:12:58 PM
-- Design Name: 
-- Module Name: Extend - Behavioral
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

entity Extend is
    Port ( Imm : in STD_LOGIC_VECTOR (23 downto 0);
           ImmSRc : in STD_LOGIC;
           ExtImm : out STD_LOGIC_VECTOR (31 downto 0));
end Extend;

architecture Behavioral of Extend is
signal Immin : std_logic_vector(25 downto 0);
begin
process(Imm,ImmSRc)
begin 
    if(ImmSRc='1') then
        Immin <= Imm & "00"; -- multipl x4  to 26 bit 
        ExtImm <= (31 downto 26 => Immin(25)) & Immin; --sign extention with MSB most significant bit
    elsif (ImmSRc='0') then
        ExtImm <=(31 downto 12 => '0') & Imm(11 downto 0); -- zero extention
    end if;
end process;

end Behavioral;
