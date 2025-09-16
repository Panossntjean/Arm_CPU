----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/13/2025 06:18:06 PM
-- Design Name: 
-- Module Name: step5 - Behavioral
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

entity step5 is
    Port ( pcp4 : in STD_LOGIC_VECTOR (31 downto 0);
           ALUResult : in STD_LOGIC_VECTOR (31 downto 0);
           ALUResults : in STD_LOGIC_VECTOR (31 downto 0);
           RD : in STD_LOGIC_VECTOR (31 downto 0);
           MemtoReg : in STD_LOGIC;
           PCSrc : in STD_LOGIC_VECTOR (1 downto 0);
           PCs : out STD_LOGIC_VECTOR (31 downto 0);
           Result : out STD_LOGIC_VECTOR (31 downto 0));
end step5;

architecture Structural of step5 is

component MUX is
generic(WIDTH : positive := 32);
port (
    A0: in STD_LOGIC_VECTOR(WIDTH-1 DOWNTO 0);
    A1: in STD_LOGIC_VECTOR(WIDTH-1 DOWNTO 0);
    S: in STD_LOGIC;
    Y: out STD_LOGIC_VECTOR(WIDTH-1 DOWNTO 0));
end component;

component mux4to1 
generic(WIDTH : positive := 32);
    Port (
        A0: in STD_LOGIC_VECTOR(WIDTH-1 DOWNTO 0);
        A1: in STD_LOGIC_VECTOR(WIDTH-1 DOWNTO 0);
        A2: in STD_LOGIC_VECTOR(WIDTH-1 DOWNTO 0);
        A3: in STD_LOGIC_VECTOR(WIDTH-1 DOWNTO 0);
        S: in STD_LOGIC_VECTOR(1 DOWNTO 0);
        Y: out STD_LOGIC_VECTOR(WIDTH-1 DOWNTO 0));
end component;

signal resultn : STD_LOGIC_VECTOR (31 downto 0);

begin

U1 : MUX port map(A0=> ALUResults ,A1=> RD , S=> MemtoReg, Y=> resultn);

U2 : mux4to1 port map ( A0 => pcp4, A1 => ALUResult , A2=> resultn, A3=> (others=>'0'), S=> PCSrc,Y=>PCs);

end Structural;
