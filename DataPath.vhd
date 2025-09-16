----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/04/2025 01:01:33 PM
-- Design Name: 
-- Module Name: DataPath - Behavioral
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
library UNISIM;
use UNISIM.VComponents.all;

entity DataPath is
generic (M       : positive := 32);  -- Word length
port ( 
       
       CLK         :in  STD_LOGIC;
       RESET       :in  STD_LOGIC:='0';
       RegSrc      :in  STD_LOGIC_VECTOR (1 downto 0);
       AluSrc      :in  std_logic;
       MemtoReg    :in  std_logic;
       ALU_CONTROL :in  STD_LOGIC_VECTOR (3 downto 0);
       ImmSrc      :in  std_logic;
       IRWrite     :in  std_logic;
       RegWrite    :in  STD_LOGIC;
       MAWrite     :in  STD_LOGIC;
       MemWrite    :in  STD_LOGIC;             --Write to RAM
       FlagsWrite  :in  STD_LOGIC;
       PCSrc       :in  STD_LOGIC_VECTOR (1 downto 0);
       PCWrite     :in  STD_LOGIC;
       instro       :out std_logic_vector (M-1 downto 0);
       flags       :out std_logic_vector (3 downto 0);
       PCounter    :out std_logic_vector (M-1 downto 0);
       ALUResult   :out std_logic_vector (M-1 downto 0);
       WriteDatao   :out std_logic_vector (M-1 downto 0);
       Result      :out std_logic_vector (M-1 downto 0));
end DataPath;

architecture Structural of DataPath is

--internal signals so we can make this happen dude.
signal pc : std_logic_vector(M-1 downto 0);
signal pcq : std_logic_vector(M-1 downto 0);
signal pcp4 : std_logic_vector(M-1 downto 0);
signal instrn : std_logic_vector(M-1 downto 0);
signal instrq : std_logic_vector(M-1 downto 0);
signal pcp4q : std_logic_vector(M-1 downto 0);
signal rd1n : std_logic_vector(M-1 downto 0);
signal rd2n : std_logic_vector(M-1 downto 0);
signal rd1q : std_logic_vector(M-1 downto 0);
signal rd2q : std_logic_vector(M-1 downto 0);
signal extn : std_logic_vector(M-1 downto 0);
signal extq : std_logic_vector(M-1 downto 0);
signal wdn : std_logic_vector(M-1 downto 0);
signal ALUResultn : std_logic_vector(M-1 downto 0); -- maybe not needed ? 
signal wdq : std_logic_vector(M-1 downto 0);
signal ALUResultq : std_logic_vector(M-1 downto 0);
signal ALUResults : std_logic_vector(M-1 downto 0);
signal ALUResultsq : std_logic_vector(M-1 downto 0);
signal ALUResultwd3 : std_logic_vector(M-1 downto 0);
signal flagsn : std_logic_vector(3 downto 0);
signal flagsq : std_logic_vector(3 downto 0);
signal rdn : std_logic_vector(M-1 downto 0);
signal rdq : std_logic_vector(M-1 downto 0);
signal ALUres : std_logic_vector(M-1 downto 0);
signal WriteDatan : std_logic_vector(M-1 downto 0);

--components

component Regg 
generic(WIDTH : positive := 32);
    Port ( CLK : in STD_LOGIC;
           RESET : in STD_LOGIC;
           D : in STD_LOGIC_VECTOR (WIDTH-1 downto 0);
           Q : out STD_LOGIC_VECTOR (WIDTH-1 downto 0));
          
end component;

component ReggWE 
generic(WIDTH : positive := 32);
Port (     CLK : in STD_LOGIC;
           RESET : in STD_LOGIC;
           WE : in STD_LOGIC;
           D : in STD_LOGIC_VECTOR (WIDTH-1 downto 0);
           Q : out STD_LOGIC_VECTOR (WIDTH-1 downto 0));
end component;

component step1 
generic (
    a : positive := 6;
    b : positive := 32);
    Port ( pc : in STD_LOGIC_VECTOR (b-1 downto 0);
           instr : out STD_LOGIC_VECTOR (b-1 downto 0);
           pcp4 : out STD_LOGIC_VECTOR (b-1 downto 0));
end component;


component step2_5 
generic (
    c : positive := 6;
    d : positive := 32);
    Port ( CLK : in STD_LOGIC;
           instr : in STD_LOGIC_VECTOR (d-1 downto 0);
           pcp4 : in STD_LOGIC_VECTOR (d-1 downto 0);
           RegSrc : in STD_LOGIC_VECTOR (1 downto 0);
           RegWrite : in STD_LOGIC;
           ImmSrc : in STD_LOGIC;
           wd : in STD_LOGIC_VECTOR (d-1 downto 0);
           rd1 : out STD_LOGIC_VECTOR (d-1 downto 0);
           rd2 : out STD_LOGIC_VECTOR (d-1 downto 0);
           ext : out STD_LOGIC_VECTOR (d-1 downto 0));
end component;

component step3 
    Port ( SrcA : in STD_LOGIC_VECTOR (31 downto 0);
           ExtImm : in STD_LOGIC_VECTOR (31 downto 0);
           ALUSrc : in STD_LOGIC;
           ALUControl : in STD_LOGIC_VECTOR (3 downto 0);
           ALUResult : out STD_LOGIC_VECTOR (31 downto 0);
           WriteData : inout STD_LOGIC_VECTOR (31 downto 0);
           flags : out STD_LOGIC_VECTOR (3 downto 0));
end component;

component DM --step4
generic (
    e : positive := 5;
    f : positive := 32); 
    Port ( CLK : in STD_LOGIC;
           WE : in STD_LOGIC;
           A : in STD_LOGIC_VECTOR (f-1 downto 0);
           WD : in STD_LOGIC_VECTOR (f-1 downto 0);
           RD : out STD_LOGIC_VECTOR (f-1 downto 0));
end component;

component step5 
    Port ( pcp4 : in STD_LOGIC_VECTOR (31 downto 0);
           ALUResult : in STD_LOGIC_VECTOR (31 downto 0);
           ALUResults : in STD_LOGIC_VECTOR (31 downto 0);
           RD : in STD_LOGIC_VECTOR (31 downto 0);
           MemtoReg : in STD_LOGIC;
           PCSrc : in STD_LOGIC_VECTOR (1 downto 0);
           PCs : out STD_LOGIC_VECTOR (31 downto 0);
           Result : out STD_LOGIC_VECTOR (31 downto 0));
end component;

begin
ALUResult <= ALUResultn;
WriteDatao <= WriteDatan;
PCounter <= pcq;
instro <= instrq;
Result <= ALUResultwd3; 

U1 : ReggWE port map(CLK=> CLK, RESET=> RESET, WE=> PCWrite,D=> pc, Q=> pcq);

U2 : step1 port map (pc => pcq, instr=> instrn, pcp4=> pcp4);

U3 : ReggWE port map(CLK=> CLK, RESET=> RESET, WE=> IRWrite,D=> instrn, Q=> instrq);

U4 : Regg port map(CLK=> CLK, RESET=> RESET,D=> pcp4, Q=> pcp4q);

U5 : step2_5 port map(CLK=> CLK, instr=> instrq,pcp4=> pcp4q, RegSrc=> RegSrc,RegWrite=> RegWrite, ImmSrc=> ImmSrc,wd=> ALUResultwd3,rd1 => rd1n, rd2=> rd2n, ext=> extn);

U6 : Regg port map(CLK=> CLK, RESET=> RESET,D=> rd1n, Q=> rd1q);

U7 : Regg port map(CLK=> CLK, RESET=> RESET,D=> rd2n, Q=> rd2q);

U8 : Regg port map(CLK=> CLK, RESET=> RESET,D=> extn, Q=> extq);

U9 : step3 port map(SrcA=> rd1q,ExtImm=> extq, ALUSrc=> AluSrc, ALUControl=> ALU_CONTROL, ALUResult=> ALUResultn,WriteData=> rd2q,flags=> flagsn); 

U10: ReggWE generic map ( width => 4)  port map(CLK=> CLK, RESET=> RESET, WE=> FlagsWrite,D=> flagsn, Q=> flags); 

U11: ReggWE port map(CLK=> CLK, RESET=> RESET, WE=> MAWrite,D=> ALUResultn, Q=> ALUResultq);

U12: Regg port map(CLK=> CLK, RESET=> RESET,D=> WriteDatan, Q=> wdq);

U13: Regg port map(CLK=> CLK, RESET=> RESET,D=> ALUResultn, Q=> ALUResults);

U14: DM port map(CLK=> CLK, WE=> MemWrite, A=> ALUResultq, WD=> wdq, RD=> rdn);

U15: Regg port map(CLK=> CLK, RESET=> RESET,D=> rdn, Q=> rdq);

U16: step5 port map(pcp4=> pcp4q,ALUResult=> ALUResultn, ALUResults=> ALUResults, RD=> rdq, MemtoReg=> MemtoReg,PCSrc=> PCSrc, PCs=> pc, Result=> ALUResultwd3);
  

end Structural;
