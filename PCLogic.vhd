----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/04/2025 05:47:19 PM
-- Design Name: 
-- Module Name: PCLogic - Behavioral
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


entity PCLogic is
    Port ( Rd : in STD_LOGIC_VECTOR (3 downto 0);
         op : in STD_LOGIC; -- op[1]
         RegWrite_in : in STD_LOGIC;
         PCSrc_in : out STD_LOGIC);
end PCLogic;

architecture Behavioral of PCLogic is
begin

process(op,RegWrite_in,Rd)
begin
    PCSrc_in <= '0'; --to ensure that the rest of the options set this to 0 
    if (Rd = "1111" and RegWrite_in = '1') then
            PCSrc_in <= '1';        
    end if; 
    
    if (op= '1' ) then
        PCSrc_in <= '1';
    end if;

end process;
end Behavioral;
