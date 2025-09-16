library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ROM_array is
generic (
    N : positive := 4;
    M : positive := 32); 
port(
    ADDR: in std_logic_vector (N-1 downto 0);
    DATA_OUT: out std_logic_vector (M-1 downto 0)
);
end ROM_array;
 
 architecture Behavioral of ROM_array is
 type ROM_array is array (2**N-1 downto 0 )
    of std_logic_vector (M-1 downto 0);
    constant ROM : ROM_array := ( 
    X"E3A00000", X"E3E01000", X"E0812000", X"E24230FF",
    X"E1A00000", X"EAFFFFF9", X"00000000", X"00000000",
    X"00000000", X"00000000", X"00000000", X"00000000",
    X"00000000", X"00000000", X"00000000", X"00000000");
 begin 
 DATA_OUT <= ROM(to_integer(unsigned(ADDR)));
 end Behavioral;