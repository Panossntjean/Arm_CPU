library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity Adder is
  generic (
    WIDTH : integer := 32
  );
  port (
--    clk, rst : in  std_logic;
    A_in, B_in : in  std_logic_vector(WIDTH-1 downto 0);
    op : in std_logic_vector(3 downto 0);
    Sum_out : out std_logic_vector(WIDTH-1 downto 0);
    Nout, Zout, Cout, Vout : out std_logic
  );
end entity;

architecture Behavioral of Adder is
--  signal sum: std_logic_vector(WIDTH downto 0);
--  signal ops: std_logic;
  
begin
    adder: process(A_in,B_in,op)
    variable A_s, B_s, S_s : unsigned (width downto 0);
    variable sum: std_logic_vector(WIDTH-1 downto 0);
     begin
     
     A_s := unsigned('0'& A_in);
     B_s := unsigned('0'& B_in);
--     ops <= std_logic(op(0));
     
      if (op = "0000") then
        S_s := A_s + B_s;
        sum := std_logic_vector(S_s(WIDTH-1 downto 0));
        Vout <= (A_in(WIDTH-1) xnor B_in(WIDTH-1)) and (S_s(WIDTH-1) xor A_in(WIDTH-1)); --overflow for add
--        Cout <= std_logic(S_s(WIDTH));
      elsif (op = "0001") then
        S_s := A_s - B_s;
        sum := std_logic_vector(S_s(WIDTH-1 downto 0));
        Vout <= (A_in(WIDTH-1) xor B_in(WIDTH-1)) and (S_s(WIDTH-1) xor A_in(WIDTH-1));  --overflow for subb
--        Cout <= std_logic(S_s(WIDTH));
      end if;
      --outputs
      Sum_out <= sum;
      
      -- overflow - flags:
     
      Nout <= std_logic(sum(WIDTH-1));
      Cout <= std_logic(S_s(WIDTH));
      
      if (S_s = 0) then Zout <= '1'; 
      else  Zout <= '0'; 
      end if;
          
  end process;
end architecture;
