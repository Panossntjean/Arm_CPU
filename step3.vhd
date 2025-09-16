----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/13/2025 06:04:49 PM
-- Design Name: 
-- Module Name: step3 - Structural
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

entity step3 is
    Port ( SrcA : in STD_LOGIC_VECTOR (31 downto 0);
--           SrcB : in STD_LOGIC_VECTOR (31 downto 0);
           ExtImm : in STD_LOGIC_VECTOR (31 downto 0);
           ALUSrc : in STD_LOGIC;
           ALUControl : in STD_LOGIC_VECTOR (3 downto 0);
           ALUResult : out STD_LOGIC_VECTOR (31 downto 0);
           WriteData : inout STD_LOGIC_VECTOR (31 downto 0);
           flags : out STD_LOGIC_VECTOR (3 downto 0));
end step3;

architecture Structural of step3 is
component MUX is
generic(WIDTH : positive := 32);
port (
    A0: in STD_LOGIC_VECTOR(WIDTH-1 DOWNTO 0);
    A1: in STD_LOGIC_VECTOR(WIDTH-1 DOWNTO 0);
    S: in STD_LOGIC;
    Y: out STD_LOGIC_VECTOR(WIDTH-1 DOWNTO 0));

end component;

component ALU 
generic (
    N : positive := 4;
    M : positive := 32); 
    Port ( SrcA : in STD_LOGIC_VECTOR (M-1 downto 0);
           SrcB : in STD_LOGIC_VECTOR (M-1 downto 0);
           ALUControl : in STD_LOGIC_VECTOR (N-1 downto 0); -- depends of # of actions
           ALUResult : out STD_LOGIC_VECTOR (M-1 downto 0);
           flags : out STD_LOGIC_VECTOR (3 downto 0)); -- fixed size for flags
end component;

signal SrcB : STD_LOGIC_VECTOR (31 downto 0); 

begin

U1 : MUX port map(A0=> WriteData ,A1=> ExtImm , S=>ALUSrc, Y=>SrcB);
 
U2 : ALU port map(SrcA => SrcA, SrcB=> SrcB, ALUControl=> ALUControl,ALUResult=> ALUResult, flags => flags);
end Structural;
