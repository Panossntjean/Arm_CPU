----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/04/2025 05:47:19 PM
-- Design Name: 
-- Module Name: WELogic - Behavioral
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

entity WELogic is
    Port ( op : in STD_LOGIC_VECTOR (1 downto 0);
           S_L : in STD_LOGIC;
           NoWrite_in : in STD_LOGIC;
           RegWrite_in : out STD_LOGIC;
           FlagsWrite_in : out STD_LOGIC;
           MemWrite_in : out STD_LOGIC);
end WELogic;

architecture Behavioral of WELogic is
begin
process(op,S_L,NoWrite_in)
begin
        RegWrite_in <= '0'; 
        MemWrite_in <= '0';
        FlagsWrite_in <= '0';
   case op is
        when "00" => 
            if (S_L='1') then
                FlagsWrite_in <= '1';                
            end if;
            
            if (NoWrite_in='0') then
                RegWrite_in <= '1';
            end if;
        when "01" => 
            if (S_L='1') then
                RegWrite_in <= '1';
            else 
                MemWrite_in <= '1';                
            end if;
            when others => 
             MemWrite_in <='0';
             FlagsWrite_in <='0';
             RegWrite_in <='0'; 
        end case;
    
end process;

end Behavioral;
