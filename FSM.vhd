----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/07/2025 10:04:41 AM
-- Design Name: 
-- Module Name: FSM - Behavioral
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


--library IEEE;
--use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
library UNISIM;
use UNISIM.VComponents.all;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.all;


entity FSM is
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
end FSM;

architecture Behavioral of FSM is

   
    type state_type is (reset_state,S0, S1, S2a, S2b, S3, S4a, S4b, S4c, S4d, S4e, S4f, S4g, S4h);
                        --  0   ,    1,  2,  3,   4,   5,  6,   7,   8,   9,   10,  11,  12,  13
    attribute enum_encoding : string;
    attribute enum_encoding of state_type : type is "00000 00001 00010 00011 00100 00101 00110 00111 01000 01001 01010 01011 01100 01101"; 
    signal current_state, next_state : state_type;
    
    signal Rd :  std_logic_vector(3 downto 0);
    signal S_L:  std_logic;
    signal op :  std_logic_vector(1 downto 0);

begin

   
    process(clk, reset)
    begin
        if reset = '1' then
            current_state <= reset_state;  
        elsif rising_edge(clk) then
            current_state <= next_state;  
        end if;
    end process;

    
    process(current_state,Instruction,CondEx_in,clk,NoWrite_in)
    begin    
        Rd <= Instruction(15 downto 12);
        S_L <= Instruction(20);
        op <= Instruction(27 downto 26);
        
        case current_state is
            when reset_state =>
               IRWrite    <= '0';
               RegWrite   <= '0'; 
               MAWrite    <= '0'; 
               MemWrite   <= '0'; 
               FlagsWrite <= '0'; 
               PCSrc      <= "00"; 
               PcWrite    <= '0';
               
               next_state <= S0;
               
            when S0 =>
               IRWrite    <= '1';
               RegWrite   <= '0'; 
               MAWrite    <= '0'; 
               MemWrite   <= '0'; 
               FlagsWrite <= '0'; 
               PCSrc      <= "00"; 
               PcWrite    <= '0';
               
               next_state <= S1;
                 
            when S1 =>
               IRWrite    <= '0';
               RegWrite   <= '0'; 
               MAWrite    <= '0'; 
               MemWrite   <= '0'; 
               FlagsWrite <= '0'; 
               PCSrc      <= "00"; 
               PcWrite    <= '0';
               
                if CondEx_in ='1' then
                    if op = "01" then 
                        next_state <= S2a;
                    elsif op = "00" then
                        if NoWrite_in = '1' then
                            next_state <= S4g;
                        else 
                            next_state <= S2b;
                        end if;
                    elsif op = "10" then -- maybe need CondEx_in = '1' ; maybe
                         next_state <= S4h;                    
                    end if;
                else
                    next_state <= S4c;
                end if;
                
            when S2a =>
               IRWrite    <= '0';
               RegWrite   <= '0'; 
               MAWrite    <= '1'; 
               MemWrite   <= '0'; 
               FlagsWrite <= '0'; 
               PCSrc      <= "00"; 
               PcWrite    <= '0';
               
                if S_L = '1' then -- apo to L tou pdf ?
                    next_state <= S3;
                else
                    next_state <= S4d;
                end if;

            when S2b =>
               IRWrite    <= '0';
               RegWrite   <= '0'; 
               MAWrite    <= '0'; 
               MemWrite   <= '0'; 
               FlagsWrite <= '0'; 
               PCSrc      <= "00"; 
               PcWrite    <= '0';
               
                if S_L = '0' then
                    if (Rd = "1111") then 
                        next_state <= S4b;
                    else 
                        next_state <= S4a;
                    end if;
                else
                    if (Rd = "1111") then 
                        next_state <= S4f;
                    else 
                        next_state <= S4e;
                    end if;
                end if;
                
            when S3 =>
               IRWrite    <= '0';
               RegWrite   <= '0'; 
               MAWrite    <= '0'; 
               MemWrite   <= '0'; 
               FlagsWrite <= '0'; 
               PCSrc      <= "00"; 
               PcWrite    <= '0';
               
                if (Rd = "1111") then 
                        next_state <= S4b;
                else 
                        next_state <= S4a;
                end if;

            when S4a =>
               IRWrite    <= '0';
               RegWrite   <= '1'; 
               MAWrite    <= '0'; 
               MemWrite   <= '0'; 
               FlagsWrite <= '0'; 
               PCSrc      <= "00"; 
               PcWrite    <= '1';
               
               next_state <= S0;
                
            when S4b =>
               IRWrite    <= '0';
               RegWrite   <= '0'; 
               MAWrite    <= '0'; 
               MemWrite   <= '0'; 
               FlagsWrite <= '0'; 
               PCSrc      <= "10"; 
               PcWrite    <= '1';
               
                next_state <= S0;
                
            when S4c =>
               IRWrite    <= '0';
               RegWrite   <= '0'; 
               MAWrite    <= '0'; 
               MemWrite   <= '0'; 
               FlagsWrite <= '0'; 
               PCSrc      <= "00"; 
               PcWrite    <= '1';
               
                next_state <= S0;
                
            when S4d =>
               IRWrite    <= '0';
               RegWrite   <= '0'; 
               MAWrite    <= '0'; 
               MemWrite   <= '1'; 
               FlagsWrite <= '0'; 
               PCSrc      <= "00"; 
               PcWrite    <= '1';
               
                next_state <= S0;
                
            when S4e =>
               IRWrite    <= '0';
               RegWrite   <= '1'; 
               MAWrite    <= '0'; 
               MemWrite   <= '0'; 
               FlagsWrite <= '1'; 
               PCSrc      <= "00"; 
               PcWrite    <= '1';
               
                next_state <= S0;
                
            when S4f =>
               IRWrite    <= '0';
               RegWrite   <= '0'; 
               MAWrite    <= '0'; 
               MemWrite   <= '0'; 
               FlagsWrite <= '1'; 
               PCSrc      <= "10"; 
               PcWrite    <= '1';
               
                next_state <= S0;
                
            when S4g =>
               IRWrite    <= '0';
               RegWrite   <= '0'; 
               MAWrite    <= '0'; 
               MemWrite   <= '0'; 
               FlagsWrite <= '1'; 
               PCSrc      <= "00"; 
               PcWrite    <= '1';
               
                next_state <= S0;
                
            when S4h =>
               IRWrite    <= '0';
               RegWrite   <= '0'; 
               MAWrite    <= '0'; 
               MemWrite   <= '0'; 
               FlagsWrite <= '0'; 
               PCSrc      <= "11"; 
               PcWrite    <= '1';
               
                next_state <= S0;
                
            when others =>
                next_state <= S0;
               
        end case;
    end process;

end Behavioral;

