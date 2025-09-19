library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity controlunit_TestB is
--  Port ( );
end controlunit_TestB;

architecture Behavioral of controlunit_TestB is
    
    component control is
        Port ( 
           clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           instr : in STD_LOGIC_VECTOR (31 downto 0);
           flags : in STD_LOGIC_VECTOR (3 downto 0);
           RegSrc : out STD_LOGIC_VECTOR (1 downto 0);
           ALUSrc : out STD_LOGIC;
           MemtoReg : out STD_LOGIC;
           ALUControl : out STD_LOGIC_VECTOR (3 downto 0);
           ImmSrc : out STD_LOGIC;
           IRWrite : out STD_LOGIC;
           RegWrite : out STD_LOGIC;
           MAWrite : out STD_LOGIC;
           MemWrite : out STD_LOGIC;
           FlagsWrite : out STD_LOGIC;
           PCSrc : out STD_LOGIC_VECTOR (1 downto 0);
           PCWrite : out STD_LOGIC
           );
    end component;
    
    signal clk,reset,ALUSrcS,MemtoRegS,ImmSrcS,IRWriteS,RegWriteS,MAWriteS,MemWriteS,FlagsWriteS, PCWriteS :STD_LOGIC;
    signal instrS : STD_LOGIC_VECTOR (31 downto 0);
    signal flagsS,ALUControlS : STD_LOGIC_VECTOR (3 downto 0);
    signal RegSrcS ,PCSrcS : STD_LOGIC_VECTOR (1 downto 0);
    
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

 --unit being tested
 uut: control port map(
        clk         =>  clk       ,
        reset       =>  reset     ,
        instr       =>  instrS     ,
        flags       =>  flagsS    ,
        RegSrc      =>  RegSrcS    ,
        ALUSrc      =>  ALUSrcS    ,
        MemtoReg    =>  MemtoRegS  ,
        ALUControl  =>  ALUControlS,
        ImmSrc      =>  ImmSrcS    ,
        IRWrite     =>  IRWriteS   ,
        RegWrite    =>  RegWriteS  ,
        MAWrite     =>  MAWriteS   ,
        MemWrite    =>  MemWriteS  ,
        FlagsWrite  =>  FlagsWriteS,
        PCSrc       =>  PCSrcS     ,
        PCWrite     =>  PCWriteS   
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
            reset <= '1';
            wait for 4*clk_period;--200ns            
            reset <= '0';
            wait for clk_period;
            --START TESTING CONTOL UNIT
            -- 0 flags from ALU at the moment irelavent for now                      
            flagsS <= "0000";
            wait for clk_period; 
            
            
            --TEST WILL DO :
            --E3A00000     --MOV R0, #0; R0 = 0x00000000
            --E5801000     --STR R1, [R0]; R1= R0;
            --E1E02001     --MVN R2, R1; R2 = 0xFFFFFFFF
            --E7923000     --LDR R3,[R2, R0];
            --E0814003     --ADD R4, R1 , R3; R4 = R1+ R3
            --E0445003     --SUB R5, R4, R3;
            --E1A00000     --MOV R0, R0;
            --E350001C     --CMP R0, #28;
            
            --Always before testing we do a reset.  
            --We first give the instruction and the reset together , when the reseto =0  then it begins
            
            
            --TEST LDR R3,[R2, R0]
            -- R3 = MEM(R2+R0)  
            wait for clk_period;
            reset <= '1';
            instrS <= x"E7923000";
            wait for clk_period;
            reset <= '0';            
            wait for 5*clk_period;
            counted_assert(MemtoRegS = '1',"Test ldr failed control send the wrong comands");
   	        
   	        --reseting
   	        --TEST STR R1, [R0]   	        
            reset <= '1';
            instrS <= x"E5801000";
            wait for clk_period;
            reset <= '0';
            wait for 4*clk_period;            
            counted_assert(MemWriteS= '1',"Test STR failed MemWrite = 1 at the last step");
            reset <= '1';
            
            --TEST CMP R0, #28
            instrS <= x"E350001C";
            
   	        wait for clk_period;
   	        reset <= '0';   	        
            wait for 3*clk_period;
            counted_assert(ALUControlS = "0001","Test cmp failed");
            reset <= '1';
            
            --TEST MOV R0, #0
            instrS <= x"E3A00000";
            
   	        wait for clk_period;
   	        reset <= '0';   	        
            wait for 5*clk_period;
            --ALUControlS is expected to be "0100" for MOV operation
            counted_assert(ALUControlS = "0100","Test MOV failed control send the wrong comands");            
   	        reset <= '1';
   	        
   	        --TEST MVN R1, #0
            instrS <= x"E3E01000";
            wait for clk_period;
   	        reset <= '0';   	        
            wait for 5*clk_period;
            --ALUControlS is expected to be "0101" for MVN operation
            counted_assert(ALUControlS = "0101","Test MVN failed control send the wrong comands");            
   	        reset <= '1';
            
            
            
   	        
   	        
   	        --TEST B
   	        
   	        --TEST BL
   	        
   	        
   	        --TEST ADD R2, R1, R0            
            instrS <= x"E0812000";
            
            wait for clk_period;
            reset <='0';
            wait for 4*clk_period;
            --ALUControlS is expected to be "0000" for ADD operation
            counted_assert(ALUControlS = "0000","Test ADD failed control send the wrong comands");
            reset <='1';
   	        wait for 2*clk_period;
   	        
   	       
            report "Test completed";
            report "Assertions occured: " &integer'image(assert_count);
            if (assert_count = 0 ) then
               report "Test PASS";
            else 
               report "Test Failed" SEVERITY ERROR;
            end if;	
            wait for 2*clk_period;
            wait;
        end process;
        


end Behavioral;
