----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/09/2025 08:17:29 PM
-- Design Name: 
-- Module Name: ALU - Behavioral
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
use IEEE.std_logic_unsigned.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU is
generic (
    N : positive := 4;
    M : positive := 32); 
    Port ( SrcA : in STD_LOGIC_VECTOR (M-1 downto 0);
           SrcB : in STD_LOGIC_VECTOR (M-1 downto 0);
           ALUControl : in STD_LOGIC_VECTOR (N-1 downto 0); -- depends of # of actions
           ALUResult : out STD_LOGIC_VECTOR (M-1 downto 0);
           flags : out STD_LOGIC_VECTOR (3 downto 0)); -- fixed size for flags
end ALU;

--architecture Behavioral of ALU is
--signal result : std_logic_vector(31 downto 0);
--signal shift : std_logic_vector(4 downto 0);
--signal shiftb : std_logic_vector(31 downto 0);
--signal carry , overflow : std_logic;
--signal tempres : std_logic_vector(32 downto 0);
--begin
--    shiftb <= SrcB;
--    shift <= shiftb(11 downto 7);
--    process(SrcA,SrcB,ALUControl)
--    begin
--        shift(4 downto 0) <= SrcB;
--        carry <= '0';
--        overflow <= '0';
--        result <= (others =>'0');
--        case ALUControl is 
--        when "0000" =>  -- ADD
--            tempres <= ('0' & SrcA) + ('0' & SrcB); -- den tin kanei kateytheian prepei na to ftiaxw
--            result <= tempres(31 downto 0);
--            carry <= tempres(32);
--            overflow <= (SrcA(31) AND SrcB(31) AND NOT tempres(31)) OR ( NOT SrcA(31) AND NOT SrcB(31) AND tempres(31)); 
--        when "0001" =>  -- SUB
--            tempres <= ('0' & SrcA) - ('0' & SrcB);
--            result <= tempres(31 downto 0);
--            carry <= tempres(32);
--            overflow <= (SrcA(31) AND NOT SrcB(31) AND NOT tempres(31)) OR ( NOT SrcA(31) AND SrcB(31) AND tempres(31));
--        when "0010" =>  -- AND
--            result <= SrcA AND SrcB;
--        when "0011" =>  -- or
--            result <= SrcA OR SrcB;
--        when "0100" =>  -- srcB   MOV
--            result <= SrcB;
--        when "0101" =>  -- notSrcB   MVN
--            result <= not SrcB;
--        when "0110"  =>  -- xor
--            result <= SrcA XOR SrcB;
--        when "1000"  =>  -- lsl
--            result <= std_logic_vector(shift_left(unsigned(SrcA),to_INTEGER(unsigned(shift)))); 
--        when "1001"  =>  -- lsr
--            result <= std_logic_vector(shift_right(unsigned(SrcA),to_INTEGER(unsigned(shift)))); 
--        when "1010"  =>  -- asr
--            result <= std_logic_vector(shift_right(signed(SrcA), to_integer(unsigned(shift))));
--        when "1011"  =>  -- ror
--            result <= std_logic_vector(rotate_right(signed(SrcA), to_integer(unsigned(shift))));
--        when others =>  -- default
--            result <= (others =>'0');        
--        end case;
--    end process;
    
    --- outputs
--    ALUResult <= result;
    
--    flags 
--    flags(3) <= '1' when result = X"00000000" else '0';
--    flags(2) <= result(31);
--    flags(1) <= carry;
--    flags(0) <= overflow;  


--end Behavioral;



architecture mix of ALU is
    signal control : std_logic_vector(3 DOWNTO 0);
    --signals for adder
    signal adder_o : STD_LOGIC_VECTOR (31 downto 0);
    signal adder_N : STD_LOGIC;
    signal adder_Z : STD_LOGIC;
    signal adder_C : STD_LOGIC;
    signal adder_V : STD_LOGIC;
    --signals for logical
    signal log_o : STD_LOGIC_VECTOR (31 downto 0);
    signal log_N : STD_LOGIC;
    signal log_Z : STD_LOGIC;
    signal log_C : STD_LOGIC;
    signal log_V : STD_LOGIC;
    --signals for shifter
    signal shift_o : STD_LOGIC_VECTOR (31 downto 0);
    signal shift_N : STD_LOGIC;
    signal shift_Z : STD_LOGIC;
    signal shift_C : STD_LOGIC;
    signal shift_V : STD_LOGIC;
    
    component Adder is
       port(A_in, B_in : in  std_logic_vector(M-1 downto 0);
        op : in std_logic_vector(3 downto 0);
        Sum_out : out std_logic_vector(M-1 downto 0);
        Nout, Zout, Cout, Vout : out std_logic
      );
    end component;
    
    component Logical is
        port (A_in, B_in : in  std_logic_vector(M-1 downto 0);
            op : in std_logic_vector(3 downto 0);
            Output : out std_logic_vector(M-1 downto 0);
            Nout, Zout, Cout, Vout : out std_logic
          );
    end component;
    
    component Shifter is
        port (A_in, B_in : in  std_logic_vector(M-1 downto 0);
            op : in std_logic_vector(3 downto 0);
            Output : out std_logic_vector(M-1 downto 0);
            Nout, Zout, Cout, Vout : out std_logic
          );
    end component;
    
    begin
    control <= ALUControl;
    --creatin port maps 
    U1: Adder PORT MAP(A_in => SrcA,
        B_in => SrcB,
        op => Control,
        Sum_out => adder_o,
        Nout => adder_N,
        Zout => adder_Z,
        Cout => adder_C,
        Vout => adder_V);
    
    U2: Logical PORT MAP(A_in => SrcA,
        B_in => SrcB,
        Output => log_o,
        op => Control,
        Nout => log_N,
        Zout => log_Z,
        Cout => log_C,
        Vout => log_V);
    
    U3: Shifter PORT MAP(A_in => SrcA,
        B_in => SrcB,
        Output => shift_o,
        op => Control,
        Nout => shift_N,
        Zout => shift_Z,
        Cout => shift_C,
        Vout => shift_V);        
        
    ALLU : process(Control)
    begin
--    case Control is
    -- to case den dexetai polla or sta when mallon me if tha ginei auto 
    if (Control = "0000") or (Control = "0001") then  -- when we have add/sub 
        ALUResult <= adder_o;
        flags(3) <= adder_N;
        flags(2) <= adder_Z;
        flags(1) <= adder_C;
        flags(0) <= adder_V;
    elsif (Control = "0010") or (Control = "0011") or (Control = "0100") or (Control = "0101") or (Control = "0110") then 
        ALUResult <= log_o;
        flags(3) <= log_N;
        flags(2) <= log_Z;
        flags(1) <= log_C;
        flags(0) <= log_V;
    elsif (Control = "1000") or (Control = "1001") or (Control = "1010") or (Control = "1011") or (Control = "1100") or (Control = "1101") or (Control = "1110") or (Control = "1111") then
        ALUResult <= shift_o;
        flags(3) <= shift_N;
        flags(2) <= shift_Z;
        flags(1) <= shift_C;
        flags(0) <= shift_V; 
    else
        ALUResult <= (others=> '0');
        flags(3) <= '0';
        flags(2) <= '0';
        flags(1) <= '0';
        flags(0) <= '0';
    end if;
    
    --ALUResult
    --Flag
    end process;
    
end mix;