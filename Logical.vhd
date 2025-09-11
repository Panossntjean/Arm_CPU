----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/06/2025 08:37:24 AM
-- Design Name: 
-- Module Name: Logical - Behavioral
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

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Logical is
generic (
    WIDTH : integer := 32
  );
  port (
    A_in, B_in : in  std_logic_vector(WIDTH-1 downto 0);
    op : in std_logic_vector(3 downto 0);
    Output : out std_logic_vector(WIDTH-1 downto 0);
    Nout, Zout, Cout, Vout : out std_logic
  );
end Logical;

architecture Behavioral of Logical is
signal out_s : std_logic_vector(31 downto 0);
begin
   process
   begin
    case op is
     when "0010" =>  -- AND
         out_s <= A_in AND B_in;
     when "0011" =>  -- or
         out_s <= A_in OR B_in;
     when "0100" =>  -- B_in   MOV
         out_s <= B_in;
     when "0101" =>  -- notB_in   MVN
         out_s <= not B_in;
     when "0110"  =>  -- xor
         out_s <= A_in XOR B_in;
     when others =>  -- default
         out_s <= (others =>'0');        
    end case;
   end process;
   --flags 
   Nout <= '0';
   Zout <= '0';
   Cout <= '0';
   Vout <= '0';
   
end Behavioral;
