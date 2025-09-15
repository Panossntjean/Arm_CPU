----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/08/2025 04:33:24 PM
-- Design Name: 
-- Module Name: ALU_TestB - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

LIBRARY ieee;
USE ieee.std_logic_1164.ALL; 
 
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
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   --Assertion counter
   shared variable assert_count : integer :=0; 
   
   --counted assrt 
   procedure counted_assert(condition : boolean; msg : string; sev : severity_level := error) is
   begin 
    if not condition then 
        assert false report msg severity sev; 
        assert_count := assert_count +1;
    end if;
   end procedure;
 
 
 
  -- constant <clock>_period : time := 10 ns;
 
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
   variable xs : unsigned(3 downto 0);
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
        op <= "0101";
        B <= "11111111111111111111111111111111";
        wait for 200ns;
        -- fix this out put 
        counted_assert(Out_1 = "10101010101010101010101010101010", "Incorrect Result for XOR Operation.");
        wait for 100ns;
        
        
        
        --Shifting operations 
        --LSL 
        A <= "11110000000000000000000000001111";
        B <= "00000000000000000000010010000000";
        Op <= "1100";
        wait for 200ns;
        counted_assert(Out_1 = "00000000000000000001111000000000", "Icorrect Result for lsl Operation.");
        -- lsl worked perfectly 
        wait for 150ns;
        
        --LSR
        op<="1101";
        wait for 200ns;
        counted_assert(Out_1 = "0", "Icorrect Result for lsr Operation."); 
        wait for 150ns;
        
        --ASR
        op<="1110";
        wait for 200ns;
        counted_assert(Out_1 = "0", "Icorrect Result for asr Operation.");
        wait for 150ns;
        
        --ROR
        op<="1111";
        wait for 200ns;
        counted_assert(Out_1 = "0", "Icorrect Result for ror Operation.");
        wait for 150ns;
        
        
        
--		A<="11111111111111111111111111111111";
--		B<="11111111111111111111111111111111";
--		Op<="0000";
--		wait for 50 ns;
--     	A<="00000000000000000000000000000000";
--		B<="00000000000000000000000000000001";
--		Op<="0000";
--      wait for 50 ns;
--	   A<="10000100000000000000000011111111";
--		B<="10110011111111111111111111111111";
--		Op<="0000";
--      wait for 50 ns;
--		A<="00000000000000000000000000000001";
--		B<="00000000000000000000000000000001";
--		Op<="0001";
--      wait for 50 ns;
--	   A<="01111111111111111111111111111111";
--		B<="10100000000000001111111100000110";
--		Op<="0001";
--      wait for 50 ns;	
--		A<="11111111000000000000000000000111";
--		B<="11111111100000000000000000000001";
--		Op<="0000";
--      wait for 50 ns;
--	   A<="00000000000000000000000011111111";
--		B<="00000000000000000111100000000000";
--		Op<="0000";
--      wait for 50 ns;
--		A<="11111111000000000000000000000111";
--		B<="11111111100000000000000000000001";
--		Op<="0001";
--      wait for 50 ns;
--	   A<="00000000000000000000000011111111";
--		B<="00000000000000000111100000000000";
--		Op<="0001";
--      wait for 50 ns;
--		A<="00000000000000000000000011111111";
--		B<="00000000000000000111100000011000";
--		Op<="0010";
--      wait for 50 ns;
--      A<="00110000000000000010000011111111";
--		B<="00000000000000000111100000000111";
--		Op<="0011";
--      wait for 50 ns;
--	   A<="00111111111111110010000011111111";
--		B<="00000000000000000111100000000111";
--		Op<="0100";
--      wait for 50 ns;
--     	A<="11110000000000000000000000000000";
--		Op<="1001";
--      wait for 50 ns;	
--		A<="11111111111111111111111111111111";
--		Op<="1001";
--      wait for 50 ns;			
--	   A<="00000000000000000000000000000000";
--		Op<="1010";
--      wait for 50 ns;	
--		A<="00000000000000000000000000000001";
--		Op<="1010";
      wait for 50 ns;
      
      report "Test completed";
      report "Assertions occured :" & integer'image(assert_count);
      if assert_count = 0  then
   	        report "TEST PASS";
   	    else
   	        report "TEST FAIL";
   	  end if;
      wait;
   end process;

END;
