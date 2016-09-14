----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.09.2016 23:24:07
-- Design Name: 
-- Module Name: test_Decoder_ALUDecoder - Behavioral
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

entity test_Decoder_ALUDecoder is
--  Port ( );
end test_Decoder_ALUDecoder;

architecture Behavioral of test_Decoder_ALUDecoder is

component Decoder_ALUDecoder is
    Port ( Funct : in STD_LOGIC_VECTOR (4 downto 0);        -- from instruction memory
           ALUOp : in STD_LOGIC;                            -- from Decoder_MainDecoder
           ALUControl : out STD_LOGIC_VECTOR (1 downto 0);  -- to ALU
           FlagW : out STD_LOGIC_VECTOR (1 downto 0);       -- to CondLogic
           NoWrite : out STD_LOGIC );                       -- to CondLogic
end component;

signal Funct : STD_LOGIC_VECTOR (4 downto 0);        	-- from instruction memory
signal ALUOp : STD_LOGIC;                            	-- from Decoder_MainDecoder
signal ALUControl : STD_LOGIC_VECTOR (1 downto 0);  	-- to ALU
signal FlagW : STD_LOGIC_VECTOR (1 downto 0);       	-- to CondLogic
signal NoWrite : STD_LOGIC;								-- to CondLogic

-- for test bench only, flipped when scenario is tested to trigger assert statements
signal NotDP_tested : STD_LOGIC := '0';	
signal MEM_SUB_IMM_tested : STD_LOGIC := '0';		
signal ADD_tested : STD_LOGIC := '0';
signal ADDS_tested : STD_LOGIC := '0';
signal SUB_tested : STD_LOGIC := '0';  
signal SUBS_tested : STD_LOGIC := '0';
signal AND_tested : STD_LOGIC := '0';
signal ANDS_tested : STD_LOGIC := '0';
signal ORR_tested : STD_LOGIC := '0';  
signal ORRS_tested : STD_LOGIC := '0';  
signal CMP_tested : STD_LOGIC := '0';

begin
	
	testALUD : Decoder_ALUDecoder port map ( Funct, ALUOp, ALUControl, FlagW, NoWrite );
	
	process 
    begin
		
        ALUOp <= '0'; Funct( 4 downto 1 ) <= "0100"; 			wait for 50ns; NotDP_tested <= not NotDP_tested;	-- Not DP
		ALUOp <= '0'; Funct( 4 downto 1 ) <= "1100";			wait for 50ns; NotDP_tested <= not NotDP_tested;	-- Not DP
		ALUOp <= '0'; Funct( 4 downto 1 ) <= "0101";			wait for 50ns; NotDP_tested <= not NotDP_tested;	-- Not DP
		ALUOp <= '0'; Funct( 4 downto 1 ) <= "0110";			wait for 50ns; NotDP_tested <= not NotDP_tested;	-- Not DP
		ALUOp <= '0'; Funct( 4 downto 1 ) <= "0111";			wait for 50ns; NotDP_tested <= not NotDP_tested;	-- Not DP
		ALUOp <= '0'; Funct( 4 downto 1 ) <= "1101";			wait for 50ns; NotDP_tested <= not NotDP_tested;	-- Not DP
		ALUOp <= '0'; Funct( 4 downto 1 ) <= "1110";			wait for 50ns; NotDP_tested <= not NotDP_tested;	-- Not DP
		ALUOp <= '0'; Funct( 4 downto 1 ) <= "1111";			wait for 50ns; NotDP_tested <= not NotDP_tested;	-- Not DP
		
		ALUOp <= '0'; Funct( 4 downto 1 ) <= "0000"; 			wait for 50ns; MEM_SUB_IMM_tested <= not MEM_SUB_IMM_tested;	-- LDR/STR with negative Imm
		ALUOp <= '0'; Funct( 4 downto 1 ) <= "1000";			wait for 50ns; MEM_SUB_IMM_tested <= not MEM_SUB_IMM_tested;	-- LDR/STR with negative Imm
		ALUOp <= '0'; Funct( 4 downto 1 ) <= "0001";			wait for 50ns; MEM_SUB_IMM_tested <= not MEM_SUB_IMM_tested;	-- LDR/STR with negative Imm
		ALUOp <= '0'; Funct( 4 downto 1 ) <= "0010";			wait for 50ns; MEM_SUB_IMM_tested <= not MEM_SUB_IMM_tested;	-- LDR/STR with negative Imm
		ALUOp <= '0'; Funct( 4 downto 1 ) <= "0011";			wait for 50ns; MEM_SUB_IMM_tested <= not MEM_SUB_IMM_tested;	-- LDR/STR with negative Imm
		ALUOp <= '0'; Funct( 4 downto 1 ) <= "1001";			wait for 50ns; MEM_SUB_IMM_tested <= not MEM_SUB_IMM_tested;	-- LDR/STR with negative Imm
		ALUOp <= '0'; Funct( 4 downto 1 ) <= "1010";			wait for 50ns; MEM_SUB_IMM_tested <= not MEM_SUB_IMM_tested;	-- LDR/STR with negative Imm
		ALUOp <= '0'; Funct( 4 downto 1 ) <= "1011";			wait for 50ns; MEM_SUB_IMM_tested <= not MEM_SUB_IMM_tested;	-- LDR/STR with negative Imm

		ALUOp <= '1'; Funct( 4 downto 1 ) <= "0100"; Funct(0) <= '0';	wait for 50ns; ADD_tested <= not ADD_tested;	-- ADD no flag
		ALUOp <= '1'; Funct( 4 downto 1 ) <= "0100"; Funct(0) <= '1';	wait for 50ns; ADDS_tested <= not ADDS_tested;	-- ADD no flag
		
		ALUOp <= '1'; Funct( 4 downto 1 ) <= "0010"; Funct(0) <= '0';	wait for 50ns; SUB_tested <= not SUB_tested;	-- SUB no flag
		ALUOp <= '1'; Funct( 4 downto 1 ) <= "0010"; Funct(0) <= '1';	wait for 50ns; SUBS_tested <= not SUBS_tested;	-- SUB with flag
		
		ALUOp <= '1'; Funct( 4 downto 1 ) <= "0000"; Funct(0) <= '0';	wait for 50ns; AND_tested <= not AND_tested;	-- AND no flag
		ALUOp <= '1'; Funct( 4 downto 1 ) <= "0000"; Funct(0) <= '1';	wait for 50ns; ANDS_tested <= not ANDS_tested;	-- AND with flag
		
		ALUOp <= '1'; Funct( 4 downto 1 ) <= "1100"; Funct(0) <= '0';	wait for 50ns; ORR_tested <= not ORR_tested;	-- ORR no flag
		ALUOp <= '1'; Funct( 4 downto 1 ) <= "1100"; Funct(0) <= '1';	wait for 50ns; ORRS_tested <= not ORRS_tested;	-- ORR with flag
		
		ALUOp <= '1'; Funct( 4 downto 1 ) <= "1010"; Funct(0) <= '1';	wait for 50ns; CMP_tested <= not CMP_tested;	-- CMP
	
    end process;
	
	process ( NotDP_tested )
	begin 
		assert ( ALUControl = "00" and FlagW = "00" and NoWrite = '0' ) 
				 report "Not Not DP" severity warning;
	end process;
	
	process ( MEM_SUB_IMM_tested )
	begin 
		assert ( ALUControl = "01" and FlagW = "00" and NoWrite = '0' ) 
				 report "Not LDR/STR negative Imm" severity warning;
	end process;
	
	process ( ADD_tested )
	begin 
		assert ( ALUControl = "00" and FlagW = "00" and NoWrite = '0' ) 
				 report "Not ADD" severity warning;
	end process;
	
	process ( ADDS_tested )
	begin 
		assert ( ALUControl = "00" and FlagW = "11" and NoWrite = '0' ) 
				 report "Not ADDS" severity warning;
	end process;
	
	process ( SUB_tested )
	begin 
		assert ( ALUControl = "01" and FlagW = "00" and NoWrite = '0' ) 
				 report "Not SUB" severity warning;
	end process;
	
	process ( SUBS_tested )
	begin 
		assert ( ALUControl = "01" and FlagW = "11" and NoWrite = '0' ) 
				 report "Not SUBS" severity warning;
	end process;
	
	process ( AND_tested )
	begin 
		assert ( ALUControl = "10" and FlagW = "00" and NoWrite = '0' ) 
				 report "Not AND" severity warning;
	end process;
	
	process ( ANDS_tested )
	begin 
		assert ( ALUControl = "10" and FlagW = "10" and NoWrite = '0' ) 
				 report "Not ANDS" severity warning;
	end process;
	
	process ( ORR_tested )
	begin 
		assert ( ALUControl = "11" and FlagW = "00" and NoWrite = '0' ) 
				 report "Not ORR" severity warning;
	end process;
	
	process ( ORRS_tested )
	begin 
		assert ( ALUControl = "11" and FlagW = "10" and NoWrite = '0' ) 
				 report "Not ORRS" severity warning;
	end process;
	
	process ( CMP_tested )
	begin 
		assert ( ALUControl = "01" and FlagW = "11" and NoWrite = '1' ) 
				 report "Not CMP" severity warning;
	end process;

end Behavioral;
