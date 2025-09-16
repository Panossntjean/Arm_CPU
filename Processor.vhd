----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/04/2025 01:01:00 PM
-- Design Name: 
-- Module Name: Processor - Behavioral
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

entity Processor is

generic (
M       : positive := 32;  -- Word length
Flag_LEN: positive := 4
);

port ( CLK         :in  STD_LOGIC;
       RESET       :in  STD_LOGIC;
       PCounter    :out std_logic_vector (M-1 downto 0);
       Instruction :out std_logic_vector (M-1 downto 0);
       ALUResult   :out std_logic_vector (M-1 downto 0);
       WriteData   :out std_logic_vector (M-1 downto 0);
       Result      :out std_logic_vector (M-1 downto 0));

end Processor;

architecture proc of Processor is

component control 
    Port ( 
           clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           instr : in STD_LOGIC_VECTOR (31 downto 0);
           flags : in STD_LOGIC_VECTOR (3 downto 0);
           RegSrc : out STD_LOGIC_VECTOR (1 downto 0);
           ALUSrc : out STD_LOGIC;
           MemtoReg : out STD_LOGIC;
           ALUControl : out STD_LOGIC_VECTOR (3 downto 0);
           ImmSrc : out STD_LOGIC;
           IRWrite : out STD_LOGIC;
           RegWrite : out STD_LOGIC;
           MAWrite : out STD_LOGIC;
           MemWrite : out STD_LOGIC;
           FlagsWrite : out STD_LOGIC;
           PCSrc : out STD_LOGIC_VECTOR (1 downto 0);
           PCWrite : out STD_LOGIC
           );
end component;

component DataPath
generic (M       : positive := 32);  -- Word length
port ( CLK         :in  STD_LOGIC;
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
end component;


--internal signlas out put of control unit 
signal RegSrc :  STD_LOGIC_VECTOR (1 downto 0);
signal ALUSrc :  STD_LOGIC;
signal MemtoReg : STD_LOGIC;
signal ALUControl :  STD_LOGIC_VECTOR (3 downto 0);
signal ImmSrc :  STD_LOGIC;
signal IRWrite : STD_LOGIC;
signal RegWrite : STD_LOGIC;
signal MAWrite :  STD_LOGIC;
signal MemWrite :  STD_LOGIC;
signal FlagsWrite :  STD_LOGIC;
signal PCSrc :  STD_LOGIC_VECTOR (1 downto 0);
signal PCWrite :  STD_LOGIC;

--internal signlas out put of datapath unit 
signal instrn : std_logic_vector (M-1 downto 0);
signal PCn : std_logic_vector (M-1 downto 0);
signal flagsn : std_logic_vector (3 downto 0);

begin
PCounter <= PCn;
Instruction <= instrn;
--ALUResult <=
--WriteData <= 
--Result <= 

controlunit : control port map(clk=> CLK, reset=> RESET, instr=> instrn,flags=> flagsn, RegSrc=> RegSrc, ALUSrc=> ALUSrc, MemtoReg=> MemtoReg, ALUControl=> ALUControl, ImmSrc=> ImmSrc, IRWrite=> IRWrite, RegWrite=> RegWrite, MAWrite=> MAWrite, MemWrite=> MemWrite, FlagsWrite=> FlagsWrite, PCSrc=> PCSrc, PCWrite=> PCWrite); 

datapatunit : datapath port map(CLK=> CLK,RESET=> RESET,RegSrc=> RegSrc, AluSrc=> ALUSrc, MemtoReg=> MemtoReg,    ALU_CONTROL => ALUControl,ImmSrc => ImmSrc,IRWrite=> IRWrite, RegWrite=> RegWrite, MAWrite=> MAWrite,  MemWrite=> MemWrite,    FlagsWrite=> FlagsWrite,   PCSrc => PCSrc, PCWrite=> PCWrite, instro => instrn, flags=> flagsn,  PCounter=> PCounter,ALUResult=> ALUResult,   WriteDatao=> WriteData,   Result=> Result);  
                                
                                
end proc;      
