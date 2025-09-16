----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/09/2025 06:28:40 PM
-- Design Name: 
-- Module Name: IM - Behavioral
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

entity IM is
generic (
    N : positive := 6;
    M : positive := 32); 
port(A : in STD_LOGIC_VECTOR (M-1 downto 0);
     RD : out STD_LOGIC_VECTOR (M-1 downto 0));
end IM;

architecture Behavioral of IM is
type imrom is array (2**N-1 downto 0) of std_logic_vector(M-1 downto 0);
constant rom : imrom :=(
    X"E3A00000", X"E3E01000", X"E0812000", X"E24230FF",
    X"E1A00000", X"EAFFFFF9", X"00000000", X"00000000",
    X"00000000", X"00000000", X"00000000", X"00000000",
    X"00000000", X"00000000", X"00000000", X"00000000",
    X"00000000", X"00000000", X"00000000", X"00000000",
    X"00000000", X"00000000", X"00000000", X"00000000",
    X"00000000", X"00000000", X"00000000", X"00000000",
    X"00000000", X"00000000", X"00000000", X"00000000",
    X"00000000", X"00000000", X"00000000", X"00000000",
    X"00000000", X"00000000", X"00000000", X"00000000",
    X"00000000", X"00000000", X"00000000", X"00000000",
    X"00000000", X"00000000", X"00000000", X"00000000",
    X"00000000", X"00000000", X"00000000", X"00000000",
    X"00000000", X"00000000", X"00000000", X"00000000",
    X"00000000", X"00000000", X"00000000", X"00000000",
    X"00000000", X"00000000", X"00000000", X"00000000");
    
    signal Addr : std_logic_vector(N-1 downto 0);
begin
    Addr <= A(N+1 downto 2);
    RD <= rom(to_integer(unsigned(Addr)));
end Behavioral;



