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

entity control is
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
end control;

architecture mix of control is

--internal signals 

-- output from Condlogic
signal CondEx_in : std_logic;

-- output from instrdec
signal NoWrite_in : std_logic; 

component CONDLogic
    Port ( cond : in STD_LOGIC_VECTOR (3 downto 0);
           flags : in STD_LOGIC_VECTOR(3 downto 0);
           CondEx_in : out STD_LOGIC);
end component;

component FSM
    Port (
        clk : in STD_LOGIC;          
        reset : in STD_LOGIC;
        Instruction : in std_logic_vector(31 downto 0);        
        NoWrite_in : in std_logic;
        CondEx_in : in STD_LOGIC;
        IRWrite : out STD_LOGIC;
        RegWrite : out STD_LOGIC;
        MAWrite : out STD_LOGIC;
        MemWrite : out STD_LOGIC;
        FlagsWrite : out STD_LOGIC;
        PCSrc : out STD_LOGIC_VECTOR(1 downto 0);
        PcWrite : out STD_LOGIC);
end component;


component InstrDec
   Port (     instr  : in STD_LOGIC_VECTOR (31 downto 0);
           RegSrc : out STD_LOGIC_VECTOR (1 downto 0);
           ALUSrc : out STD_LOGIC;
           ImmSrc : out STD_LOGIC;
           ALUControl : out STD_LOGIC_VECTOR (3 downto 0);
           MemtoReg : out STD_LOGIC;
           NoWrite_in : out STD_LOGIC);
end component;             
begin

U1: CONDLogic port map (cond=> instr(31 downto 28),flags=> flags,CondEx_in=> CondEx_in);

U2: FSM port map(clk=>clk, reset=>reset,Instruction=> instr,NoWrite_in=> NoWrite_in,CondEx_in=> CondEx_in, IRWrite=> IRWrite,RegWrite=> RegWrite,MAWrite=> MAWrite, MemWrite=> MemWrite, FlagsWrite=> FlagsWrite, PCSrc=> PCSrc,PCWrite=> PCWrite);

U3: InstrDec port map (instr=> instr,RegSrc=> RegSrc,ALUSrc=> ALUSrc,MemtoReg=> MemtoReg,ALUControl=> ALUControl,ImmSrc=> ImmSrc,NoWrite_in=> NoWrite_in);


end mix;
