
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library UNISIM;
use UNISIM.VComponents.all;

entity RF is
    Port ( CLK : in STD_LOGIC;
           WE3 : in STD_LOGIC; --write enable
           A1 : in STD_LOGIC_VECTOR (3 downto 0); 
           A2 : in STD_LOGIC_VECTOR (3 downto 0);
           A3 : in STD_LOGIC_VECTOR (3 downto 0); --write address
           WD3 : in STD_LOGIC_VECTOR (31 downto 0);  --write data 
           R15 : in STD_LOGIC_VECTOR (31 downto 0);
           RD1 : out STD_LOGIC_VECTOR (31 downto 0);
           RD2 : out STD_LOGIC_VECTOR (31 downto 0));
end RF;

architecture Behavioral of RF is

type r is array (14 downto 0) of std_logic_vector(31 downto 0);
signal regf : r;-- :=(others => (others=>'0'));

begin
    --reading and pc reggister
    process(A1,A2)
    begin    
    ---pc or read    
    if(A1= "1111") then
         RD1 <= R15;
    else 
        RD1 <= regf(to_integer(unsigned(A1)));       
    end if;
    
    if(A2= "1111") then
         RD2 <= R15;
    else 
         RD2 <= regf(to_integer(unsigned(A2)));
    end if;      
    end process;


    --write
    process(CLK,WE3)
    begin
    if (CLK= '1' and CLK'event) then 
            if(WE3= '1') and (A3 < "1111") then
                 regf(to_integer(unsigned(A3))) <= WD3;
            end if;
     end if;
    end process;

end Behavioral;
