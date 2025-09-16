----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/13/2025 05:39:13 PM
-- Design Name: 
-- Module Name: step2_5 - Behavioral
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

entity step2_5 is
generic (
    N : positive := 6;
    M : positive := 32);
    Port ( CLK : in STD_LOGIC;
           instr : in STD_LOGIC_VECTOR (M-1 downto 0);
           pcp4 : in STD_LOGIC_VECTOR (M-1 downto 0);
           RegSrc : in STD_LOGIC_VECTOR (2 downto 0);
           RegWrite : in STD_LOGIC;
           ImmSrc : in STD_LOGIC;
           wd : in STD_LOGIC_VECTOR (M-1 downto 0);
           rd1 : out STD_LOGIC_VECTOR (M-1 downto 0);
           rd2 : out STD_LOGIC_VECTOR (M-1 downto 0);
           ext : out STD_LOGIC_VECTOR (M-1 downto 0));
end step2_5;




architecture Structural of step2_5 is

component INC4 
    Port ( PC : in STD_LOGIC_VECTOR (M-1 downto 0);
           PCPlus4 : out STD_LOGIC_VECTOR (M-1 downto 0));
end component;

component RF 
    Port ( CLK : in STD_LOGIC;
           WE3 : in STD_LOGIC; --write enable
           A1 : in STD_LOGIC_VECTOR (3 downto 0); 
           A2 : in STD_LOGIC_VECTOR (3 downto 0);
           A3 : in STD_LOGIC_VECTOR (3 downto 0); --write address
           WD3 : in STD_LOGIC_VECTOR (31 downto 0);  --write data 
           R15 : in STD_LOGIC_VECTOR (31 downto 0);
           RD1 : out STD_LOGIC_VECTOR (31 downto 0);
           RD2 : out STD_LOGIC_VECTOR (31 downto 0));
end component;

component Extend 
    Port ( Imm : in STD_LOGIC_VECTOR (23 downto 0);
           ImmSRc : in STD_LOGIC;
           ExtImm : out STD_LOGIC_VECTOR (31 downto 0));
end component;

component MUX is
generic(WIDTH : positive := 4);
port (
    A0: in STD_LOGIC_VECTOR(WIDTH-1 DOWNTO 0);
    A1: in STD_LOGIC_VECTOR(WIDTH-1 DOWNTO 0);
    S: in STD_LOGIC;
    Y: out STD_LOGIC_VECTOR(WIDTH-1 DOWNTO 0));

end component;

--INTERNAL SIGNALS
signal pcp8 : STD_LOGIC_VECTOR (M-1 downto 0);
signal ra1 :STD_LOGIC_VECTOR (3 downto 0);
signal ra2 :STD_LOGIC_VECTOR (3 downto 0);
signal wa :STD_LOGIC_VECTOR (3 downto 0);
signal instr1 :STD_LOGIC_VECTOR (3 downto 0);
signal instr2 :STD_LOGIC_VECTOR (3 downto 0);
signal instr3 :STD_LOGIC_VECTOR (3 downto 0);
signal instr4 :STD_LOGIC_VECTOR (3 downto 0);
signal instr5 :STD_LOGIC_VECTOR (23 downto 0);
--signal instr6 :STD_LOGIC_VECTOR (3 downto 0);
--signal instr7 :STD_LOGIC_VECTOR (3 downto 0);

begin
instr1 <= instr(19 downto 16);
instr2 <= "1111";
instr3 <= instr(3 downto 0);
wa <= instr(15 downto 12);
instr5 <= instr(23 downto 0);
--instr6 <= instr(15 downto 12);
--instr7 <= "1110";



U1 : MUX port map(A0=> instr1 ,A1=> instr2 , S=>RegSrc(0) ,Y=>ra1);
U2 : MUX port map(A0=> instr3 ,A1=> wa , S=>RegSrc(1) ,Y=>ra2);
--U3 : MUX port map(A0=> instr6 ,A1=> instr7, S=>RegSrc(2) ,Y=>wa);
U3 : INC4 port map (PC=>pcp4, PCPlus4=> pcp8);
U4 : RF port map (CLK => CLK, WE3=> RegWrite, A1 => ra1, A2=> ra2, A3=> wa, WD3=> wd, R15=> pcp8, RD1=> rd1, RD2 =>rd2);
U5 : Extend port map (Imm=> instr5, ImmSrc=> ImmSrc ,ExtImm=> ext);


end Structural;
