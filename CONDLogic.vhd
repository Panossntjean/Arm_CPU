----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/04/2025 05:47:19 PM
-- Design Name: 
-- Module Name: CONDLogic - Behavioral
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

entity CONDLogic is
    Port ( cond : in STD_LOGIC_VECTOR (3 downto 0);
           flags : in STD_LOGIC_VECTOR(3 downto 0);
           CondEx_in : out STD_LOGIC);
end CONDLogic;

architecture Behavioral of CONDLogic is
signal CondEx: std_logic;
begin
process(cond,flags)
begin 
    CondEx_in <= '0';
   
    case cond(3) is
      when '0' =>               
         case cond(2 downto 1) is
             when "00" =>
                CondEx <= flags(2);
             when "01" =>
                 CondEx <= flags(1);
             when "10" =>
                CondEx <= flags(3);
             when "11" =>
                CondEx <= flags(0);
             when others =>
                CondEx <= '0';
         end case;
                  
         if(cond(0)='1') then
            CondEx_in <=std_logic( not(CondEx));
         else
            CondEx_in <= CondEx;
         end if;
         
      when '1' =>
         case cond(2downto 0) is
            when "000" =>
                CondEx_in <= not(flags(2)) and flags(1);
            when "001" =>
                CondEx_in <= flags(2)or(not(flags(1)));
            when "010" =>
                CondEx_in <= flags(3) xnor flags(0);
            when "011" =>
                CondEx_in <= flags(3) xor flags(0);
            when "100" =>
                CondEx_in <= not(flags(2)) and (flags(3) xnor flags(0));
            when "101" =>
                CondEx_in <= flags(2) or (flags(3) xor flags(0));
            when "110" =>
                CondEx_in <='1';
            when "111" =>
                CondEx_in <='1';
            when others =>
                CondEx_in <='0';
         end case; 
       when others =>
          CondEx_in <='0';        
    end case;
       
end process;

end Behavioral;
