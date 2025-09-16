----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/06/2025 09:26:34 AM
-- Design Name: 
-- Module Name: control - Behavioral
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

entity control1cycle is
    Port ( instr : in STD_LOGIC_VECTOR (31 downto 0);
           flags : in STD_LOGIC_VECTOR (3 downto 0);
           RegSrc : out STD_LOGIC_VECTOR (1 downto 0);
           ALUSrc : out STD_LOGIC;
           MemtoReg : out STD_LOGIC;
           ALUControl : out STD_LOGIC_VECTOR (1 downto 0);
           ImmSrc : out STD_LOGIC;
           MemWrite : out STD_LOGIC;
           FlagsWrite : out STD_LOGIC;
           RegWrite : out STD_LOGIC;
           PCSrc : out STD_LOGIC
           );
end control1cycle;

architecture mix of control1cycle is

--internal signals 

-- output from Condlogic
signal CondEx_in : std_logic; 
-- output from Pclogic
signal PCSrc_in : std_logic;  
-- output from welogic
signal FlagsWrite_in : std_logic; 
signal MemWrite_in : std_logic;
signal RegWrite_in : std_logic;

-- output from instrdec
signal RegSrc_in : std_logic; 
signal ALUSrc_in : std_logic; -- maybe 
signal MemtoReg_in : std_logic;-- not needed 
signal NoWrite_in : std_logic; -- definately internal 

component CONDLogic
    Port ( cond : in STD_LOGIC_VECTOR (3 downto 0);
           flags : in STD_LOGIC_VECTOR(3 downto 0);
           CondEx_in : out STD_LOGIC);
end component;

component PCLogic 
    Port ( Rd : in STD_LOGIC_VECTOR (3 downto 0);
           op : in STD_LOGIC; -- op[1]
           RegWrite_in : in STD_LOGIC;
           PCSrc_in : out STD_LOGIC);
end component;

component WELogic
    Port ( op : in STD_LOGIC_VECTOR (1 downto 0);
           S_L : in STD_LOGIC;
           NoWrite_in : in STD_LOGIC;
           RegWrite_in : out STD_LOGIC;
           FlagsWrite_in : out STD_LOGIC;
           MemWrite_in : out STD_LOGIC);
end component;

component InstrDec
    Port ( op : in STD_LOGIC_VECTOR (1 downto 0);
           funct : in STD_LOGIC_VECTOR (5 downto 0);
           RegSrc : out STD_LOGIC_VECTOR (1 downto 0);
           ALUSrc : out STD_LOGIC;
           ImmSrc : out STD_LOGIC;
           ALUControl : out STD_LOGIC_VECTOR (1 downto 0);
           MemtoReg : out STD_LOGIC;
           NoWrite_in : out STD_LOGIC);
end component;             
begin

U1: CONDLogic port map (cond=> instr(31 downto 28),flags=> flags,CondEx_in=> CondEx_in);

U2: PCLogic port map(Rd=> instr(15 downto 12),op=> instr(27),RegWrite_in=> RegWrite_in,PCSrc_in=> PCSrc_in);

U3: WELogic port map (op=> instr(27 downto 26),S_L=> instr(20),NoWrite_in=> NoWrite_in,MemWrite_in=> MemWrite_in,FlagsWrite_in=> FlagsWrite_in,RegWrite_in=> RegWrite_in);

U4: InstrDec port map (op=> instr(27 downto 26),funct=> instr(25 downto 20),RegSrc=> RegSrc,ALUSrc=> ALUSrc,MemtoReg=> MemtoReg,ALUControl=> ALUControl,ImmSrc=> ImmSrc,NoWrite_in=> NoWrite_in);

process(CondEx_in)
begin
        MemWrite <= MemWrite_in and CondEx_in;
        FlagsWrite <= FlagsWrite_in and CondEx_in;
        RegWrite <= RegWrite_in and CondEx_in;
        PCSrc <= PCSrc_in and CondEx_in;
end process;

end mix;
