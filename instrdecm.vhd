----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/11/2025 10:21:42 AM
-- Design Name: 
-- Module Name: instrdecm - Behavioral
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

entity instrdecm is
Port (     instr  : in STD_LOGIC_VECTOR (31 downto 0);
           RegSrc : out STD_LOGIC_VECTOR (1 downto 0);
           ALUSrc : out STD_LOGIC;
           ImmSrc : out STD_LOGIC;
           ALUControl : out STD_LOGIC_VECTOR (3 downto 0);
           MemtoReg : out STD_LOGIC;
           NoWrite_in : out STD_LOGIC);
end instrdecm;

architecture Behavioral of instrdecm is
signal op : std_logic_vector(1 downto 0);
signal funct : std_logic_vector(5 downto 0);
signal cmd : std_logic_vector(3 downto 0);
signal shift : std_logic_vector(1 downto 0);
signal shiftamt : std_logic_vector(4 downto 0);
signal l,s : std_logic;
begin
op <= instr(27 downto 26);
funct <= instr(25 downto 20);
cmd <= instr(24 downto 21);
l <= instr(25);
s <= instr(20);
shift <= instr(6 downto 5);
shiftamt <= instr(11 downto 7);
process(instr,op,funct,shift)
begin
    RegSrc <= "00";
    ALUSrc <= '0';
    ImmSrc <= '0';
    ALUControl <= "0000";
    MemtoReg <= '0';
    NoWrite_in <= '0';
    case op is
        when "00" =>
            case cmd is
                when "0000" =>  --AND
                     ALUControl <= "0010";         
                when "0001"=>  --XOR
                     ALUControl <= "0110";  
                when "0010" =>  --SUBB
                     ALUControl <= "0001";  
--                     MemtoReg <= 'X';  --  ???? 
--                     NoWrite_in <= '1';   ---???
                when "0100" =>  --ADD
                     ALUControl <= "0000";  
                when "1010" => -- CMP  (subb)
                     ALUControl <= "0001";
                     NoWrite_in <= '1';
                when "1100" => -- or
                     ALUControl <= "0011";  
                when "1101" =>  -- MOV /NOP   /shift 
                     
                        --shift operations
                    if shiftamt /= "00000" then -- we have shift operation instead of mov
                        case shift is
                            when "00" => --lsl
                                ALUControl <= "1000";
                            when "01" => --lsr
                                ALUControl <= "1001";
                            when "10" => --asr
                                ALUControl <= "1010";
                            when "11" => --ror
                                ALUControl <= "1011";
                            when others=> 
                              ALUControl <= "0100"; -- mov
                            end case;
                    else -- we have move OPERATION
                          ALUControl <= "0100";  --- mov
                    end if;
                when "1111" =>  -- MVN 
                     ALUControl <= "0101";  
                when others => --default case
                    ALUControl <= "XXXX";
            end case;
            
            --set alu source based on immediate bit
            RegSrc(1) <= funct(4) and '1';-- ??  not needed 
            
            ALUSrc <= funct(5);
            ImmSrc <= '0';
            
            
            
        when "01" =>   --- load and store
             ALUSrc <= '1';
             ImmSrc <= '0';
             NoWrite_in <= '0';
             
             if s = '1' then --ldr
                ALUControl <= "000"& (not funct(3)); --add or subb operation
                RegSrc <= "00";
                MemtoReg <= '1';
             else   --- str
                ALUControl <= "000"& (not funct(3)); --add or subb operation
                RegSrc <= "10";
                MemtoReg <= '0';
             end if;
             
        when "10"=>  -- branch  /  branch link 
              RegSrc <= funct(4)&"0";
              ALUSrc <= '1';
              ImmSrc <= '1'; --sign extention
              ALUControl <= "0000";
              MemtoReg <= '0';
              NoWrite_in <= '0';    
        when others => 
                  RegSrc <= "00";
                  ALUSrc <= '0';
                  ImmSrc <= '0';
                  ALUControl <= "0010"; -- AND - DEFAULT
                  MemtoReg <= '0';
                  NoWrite_in <= '0';
    end case;
end process;


end Behavioral;

