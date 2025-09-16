library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity RF_TestB is
--  Port ( );
end RF_TestB;

architecture Behavioral of RF_TestB is
    component RF is
        Port ( CLK : in STD_LOGIC;
               WE3 : in STD_LOGIC; --write enable
               A1 : in STD_LOGIC_VECTOR (3 downto 0); 
               A2 : in STD_LOGIC_VECTOR (3 downto 0);
               A3 : in STD_LOGIC_VECTOR (3 downto 0); --write address
               WD3 : in STD_LOGIC_VECTOR (31 downto 0);  --write data 
               R15 : in STD_LOGIC_VECTOR (31 downto 0);
               RD1 : out STD_LOGIC_VECTOR (31 downto 0);
               RD2 : out STD_LOGIC_VECTOR (31 downto 0));
    end component;


    signal a1s,a2s,a3s : STD_LOGIC_VECTOR (3 downto 0);
    signal wds, r15s, rd1s, rd2s : STD_LOGIC_VECTOR (31 downto 0);
    signal wes,clk : std_logic;
    
    constant clk_period : time := 50 ns;
    
   --assertion counter
   shared variable assert_count : integer := 0; 
   
    -- Helper: counted assert
    procedure counted_assert(condition : boolean; msg : string; sev : severity_level := error) is
    begin
        if not condition then
            assert false report msg severity sev;
            assert_count := assert_count + 1;    
        end if;
    end procedure;


   begin

    --unit
    UUT: RF port map(
             CLK  => clk,
             WE3  => wes,
             A1   => a1s,
             A2   => a2s,
             A3   => a3s,
             WD3  => wds,
             R15  => r15s,
             RD1  => rd1s,
             RD2  => rd2s
    );
    
    clk_process :process
       begin
            clk <= '0';
            wait for clk_period/2;
            clk <= '1';
            wait for clk_period/2;
       end process;
       
       
    sim_process: process
    begin 
      wait for clk_period;
      wes <= '0'; --read
      r15s <= x"ffffffff";  
      wait for clk_period;
      wes <= '1'; --write en
      wait for clk_period;
      --write something
      a3s <= "0001";
      wds <= x"aceabace";
      wait for clk_period; 
      wes <= '0';--stop writing      
      wait for clk_period;      
      a1s <= "0001";--read
      wait for clk_period; 
      wes <= '1';--write
      wait for clk_period;
      a3s <= "0010";
      wds <= x"faceacee";
      wait for clk_period;
      wes <= '0';--stop writing
      wait for clk_period;
      a2s <= "0010";--read
      wait for clk_period;      
      a1s <= "1111";
      a2s <= "1111";
      wait for clk_period;
      
      -- for assertion? we check rd1s and rd2s



      wait for 2*clk_period;--100ns
      
      report "Test completed";
      report "Assertions occured: " &integer'image(assert_count);
      if (assert_count = 0 ) then
   	     report "Test PASS";
   	  else 
   	     report "Test Failed"; 
   	  end if;	
   	  wait for 2*clk_period;
      wait;
    end process;

end Behavioral;
