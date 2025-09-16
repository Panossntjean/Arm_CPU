----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/09/2025 08:03:37 PM
-- Design Name: 
-- Module Name: DM - Behavioral
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

entity DM is
generic (
    N : positive := 5;
    M : positive := 32); 
    Port ( CLK : in STD_LOGIC;
           WE : in STD_LOGIC;
           A : in STD_LOGIC_VECTOR (M-1 downto 0);
           WD : in STD_LOGIC_VECTOR (M-1 downto 0);
           RD : out STD_LOGIC_VECTOR (M-1 downto 0));
end DM;

architecture Behavioral of DM is
type ram_array is array (2**N-1 downto 0) of std_logic_vector (M-1 downto 0);
signal RAM : ram_array;
signal addr: std_logic_vector(N-1 downto 0);
begin
    addr <= A(N+1 downto 2);
--DIFERENT PROCESS FOR READ AND WRITE SINCE ONE IS ASYCHONOUS AND OTHER IS SYNCHRONUS
    --READ  is asychronous
    RD <= RAM(to_integer(unsigned(addr)));
    -- WRITE
    process(CLK)
    begin
        if (CLK= '1' and CLK'event) then 
            if(WE= '1') then
                 RAM(to_integer(unsigned(addr))) <= WD;
            end if;
     end if;
    end process;
    
end Behavioral;
