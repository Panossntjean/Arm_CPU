----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/13/2025 05:28:59 PM
-- Design Name: 
-- Module Name: step1 - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity step1 is
generic (
    N : positive := 6;
    M : positive := 32);
    Port ( pc : in STD_LOGIC_VECTOR (31 downto 0);
           instr : out STD_LOGIC_VECTOR (31 downto 0);
           pcp4 : out STD_LOGIC_VECTOR (31 downto 0));
end step1;

architecture Structural of step1 is

component IM
port(A : in STD_LOGIC_VECTOR (31 downto 0);
     RD : out STD_LOGIC_VECTOR (31 downto 0));
end component;

component INC4 
    Port ( PC : in STD_LOGIC_VECTOR (31 downto 0);
           PCPlus4 : out STD_LOGIC_VECTOR (31 downto 0));
end component;

begin

   U1: IM port map (A=>pc,RD=>instr);
   
   U2: INC4 port map (PC=>pc, PCPlus4=> pcp4);

end Structural;
