library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU_TestB is
--  Port ( );
end ALU_TestB;

architecture Behavioral of ALU_TestB is
 
    -- Component Declaration for the Unit Under Test (UUT)
     COMPONENT ALU
    Port ( SrcA : in STD_LOGIC_VECTOR (31 downto 0);
           SrcB : in STD_LOGIC_VECTOR (31 downto 0);
           ALUControl : in STD_LOGIC_VECTOR (3 downto 0); -- depends of # of actions
           ALUResult : out STD_LOGIC_VECTOR (31 downto 0);
           flags : out STD_LOGIC_VECTOR (3 downto 0));
    END COMPONENT;
       
   --Inputs
   signal A : std_logic_vector(31 downto 0) := (others => '0');
   signal B : std_logic_vector(31 downto 0) := (others => '0');
   signal Op : std_logic_vector(3 downto 0) := (others => '0');
 
 	--Outputs
   signal Out_1 : std_logic_vector(31 downto 0);
   signal flags_out : std_logic_vector(3 downto 0) := (others => '0');
  
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
  
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ALU PORT MAP (
          SrcA => A, 
          SrcB => B,
          ALUControl => Op,
          ALUResult => Out_1,
          flags => flags_out);
   -- Stimulus process
   stim_proc: process   
   begin	
        -- Testing 
        -- Arithmetical operations
        
        --ADD 
        A<="00000000000000000000000000000101";
		B<="00000000000000000000000000000011";
		Op<="0000";  
        
   	    wait for 110ns;
   	    counted_assert(Out_1 = "00000000000000000000000000001000" , "ADD failed");
   	    wait for 100ns;
   	    --SUBB
   	    A<="10000000000000000000000000000000";
		B<="01000000000000000000000000000000";
		Op<="0001";  
        
   	    wait for 200ns;
   	    counted_assert(flags_out(0) = '1',"Test SUB overflow failed overflow did not occure");
   	    wait for 100 ns;
   	    
   	    --Logical operations 
   	    --AND
   	    A <= "01010101010101010101010101010101";
        B <= "11111111111111111111111111111111";
        op <= "0010";
        wait for 200ns;
        counted_assert(Out_1 = "01010101010101010101010101010101", "Incorrect Result for AND Operation.");
        wait for 100ns;
        
        --OR
        op <= "0011";
        wait for 200ns;
        counted_assert(Out_1 = "11111111111111111111111111111111", "Incorrect Result for OR Operation.");
        wait for 100ns;
        
        --MOV (B pass through)
        op <= "0100";
        B <= "11111111111111111101111111111111";
        wait for 200ns;
        counted_assert(Out_1 = "11111111111111111101111111111111", "Incorrect Result for MOV Operation.");
        wait for 100ns;
        
        --MVN (NOTB)
        op <= "0101";
        B <= "11111111111111111101111111111111";
        wait for 200ns;
        counted_assert(Out_1 = "00000000000000000010000000000000", "Incorrect Result for MVN Operation.");
        wait for 100ns;
        
        --XOR         
        A <= "01010101010101010101010101010101";
        B <= "11111111111111111111111111111111";
        op <= "0110";
        wait for 200ns;
        counted_assert(Out_1 = "10101010101010101010101010101010", "Incorrect Result for XOR Operation.");
        wait for 100ns;
        
        
        
        --Shifting operations 
        --LSL 
        A <= "11110000000000000000000000001111";
        B <= "00000000000000000000010010000000";
        Op <= "1100";
        wait for 200ns;
        counted_assert(Out_1 = "00000000000000000001111000000000", "Icorrect Result for lsl Operation.");
        wait for 150ns;
        
        --LSR
        op<="1101";
        wait for 200ns;
        counted_assert(Out_1 = "00000000011110000000000000000000", "Icorrect Result for lsr Operation."); 
        wait for 150ns;
        
        --ASR
        op<="1110";
        wait for 200ns;
        counted_assert(Out_1 = "11111111111110000000000000000000", "Icorrect Result for asr Operation.");
        wait for 150ns;           
        
        --ROR
        op<="1111";
        wait for 200ns;
        counted_assert(Out_1 = "00000111111110000000000000000000", "Icorrect Result for ror Operation.");
        wait for 150ns;
        
        
        
      wait for 50 ns;
      
      report "Test completed";
      report "Assertions occured: " &integer'image(assert_count);
      if (assert_count = 0 ) then
   	     report "Test PASS";
   	  else 
   	     report "Test Failed"; 
   	  end if;	
   	  wait for 50ns;
      wait;
   end process;

end Behavioral;