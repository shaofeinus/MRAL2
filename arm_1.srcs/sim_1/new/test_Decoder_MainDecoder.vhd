----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.09.2016 21:29:05
-- Design Name: 
-- Module Name: test_Decoder_MainDecoder - Behavioral
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

entity test_Decoder_MainDecoder is
--  Port ( );
end test_Decoder_MainDecoder;

architecture Behavioral of test_Decoder_MainDecoder is

component Decoder_MainDecoder is
    Port ( Op : in STD_LOGIC_VECTOR (1 downto 0);       -- from instruction memory 
           Funct5 : in STD_LOGIC;    					-- from instruction memory
		   Funct0 : in STD_LOGIC;						-- from instruction memory
           Branch : out STD_LOGIC;                      -- to Decoder_PCLogic
           RegW : out STD_LOGIC;                        -- to CondLogic and Decoder_PCLogic
           MemW : out STD_LOGIC;                        -- to CondLogic
           MemtoReg : out STD_LOGIC;                    -- to mux in ARM (output of data memory)
           ALUSrc : out STD_LOGIC;                      -- to mux in ARM (input of ALU)
           ImmSrc : out STD_LOGIC_VECTOR (1 downto 0);  -- to Extend
           RegSrc : out STD_LOGIC_VECTOR (1 downto 0);  -- to mux in ARM (input of RegFile)
           ALUOp : out STD_LOGIC);                      -- to Decoder_ALUDecoder
end component;

signal Op : STD_LOGIC_VECTOR (1 downto 0);      -- from instruction memory 
signal Funct5 : STD_LOGIC;   					-- from instruction memory
signal Funct0 : STD_LOGIC;   					-- from instruction memory
signal Branch : STD_LOGIC;                      -- to Decoder_PCLogic
signal RegW : STD_LOGIC;                        -- to CondLogic and Decoder_PCLogic
signal MemW : STD_LOGIC;                        -- to CondLogic
signal MemtoReg : STD_LOGIC;                    -- to mux in ARM (output of data memory)
signal ALUSrc : STD_LOGIC;                      -- to mux in ARM (input of ALU)
signal ImmSrc : STD_LOGIC_VECTOR (1 downto 0);  -- to Extend
signal RegSrc : STD_LOGIC_VECTOR (1 downto 0);  -- to mux in ARM (input of RegFile)
signal ALUOp : STD_LOGIC;

-- for test bench only, flipped when scenario is tested to trigger assert statements
signal DPReg_tested : STD_LOGIC := '0';			
signal DPImm_tested : STD_LOGIC := '0';
signal STR_tested : STD_LOGIC := '0';  
signal LDR_tested : STD_LOGIC := '0';
signal B_tested : STD_LOGIC := '0';                   
    
begin
    
    testDMD : Decoder_MainDecoder port map(Op, Funct5, Funct0, Branch, RegW, MemW, MemtoReg, ALUSrc, ImmSrc, RegSrc, ALUOp);
    
    process 
    begin
	
        Op <= "00"; Funct5 <= '0';  				wait for 50ns; DPReg_tested <= not DPReg_tested;	-- DP Reg
		Op <= "00"; Funct5 <= '0'; Funct0 <= '0';	wait for 50ns; DPReg_tested <= not DPReg_tested;	-- DP Reg (with varying Funct0)
		Op <= "00"; Funct5 <= '0'; Funct0 <= '1';	wait for 50ns; DPReg_tested <= not DPReg_tested;	-- DP Reg (with varying Funct0)
		
        Op <= "00"; Funct5 <= '1'; 					wait for 50ns; DPImm_tested <= not DPImm_tested;	-- DP Imm
		Op <= "00"; Funct5 <= '1'; Funct0 <= '0';	wait for 50ns; DPImm_tested <= not DPImm_tested;	-- DP Imm (with varying Funct0)
		Op <= "00"; Funct5 <= '1'; Funct0 <= '1';	wait for 50ns; DPImm_tested <= not DPImm_tested;	-- DP Imm (with varying Funct0)
		
		Op <= "01"; Funct0 <= '0'; 					wait for 50ns; STR_tested <= not STR_tested;		-- STR
		Op <= "01"; Funct0 <= '0'; Funct5 <= '0';	wait for 50ns; STR_tested <= not STR_tested;		-- STR (with varying Funct5)
		Op <= "01"; Funct0 <= '0'; Funct5 <= '1';   wait for 50ns; STR_tested <= not STR_tested;		-- STR (with varying Funct5)
		
        Op <= "01"; Funct0 <= '1'; 					wait for 50ns; LDR_tested <= not LDR_tested;		-- LDR
		Op <= "01"; Funct0 <= '1'; Funct5 <= '0';	wait for 50ns; LDR_tested <= not LDR_tested;		-- LDR (with varying Funct5)
		Op <= "01"; Funct0 <= '1'; Funct5 <= '1';   wait for 50ns; LDR_tested <= not LDR_tested;		-- LDR (with varying Funct5)
		
		Op <= "10";				 					wait for 50ns; B_tested <= not B_tested;			-- B
		Op <= "10";	Funct0 <= '0'; Funct5 <= '0';	wait for 50ns; B_tested <= not B_tested;			-- B (with varying Funct0 and Funct5)
		Op <= "10";	Funct0 <= '0'; Funct5 <= '1';	wait for 50ns; B_tested <= not B_tested;			-- B (with varying Funct0 and Funct5)
		Op <= "10";	Funct0 <= '1'; Funct5 <= '0';	wait for 50ns; B_tested <= not B_tested;			-- B (with varying Funct0 and Funct5)
		Op <= "10";	Funct0 <= '1'; Funct5 <= '1';	wait for 50ns; B_tested <= not B_tested;			-- B (with varying Funct0 and Funct5)
		
    end process;
	
	-- test for DP Reg
	process ( DPReg_tested )
	begin 
		assert ( Branch = '0' and MemtoReg = '0' and MemW = '0' and ALUSrc = '0' and 
				 ImmSrc = "XX" and RegW = '1' and RegSrc = "00" and ALUOp = '1' ) 
				 report "Not DP Reg" severity warning;
	end process;
	
	-- test for DP Imm
	process ( DPImm_tested )
	begin 
		assert ( Branch = '0' and MemtoReg = '0' and MemW = '0' and ALUSrc = '1' and 
				 ImmSrc = "00" and RegW = '1' and RegSrc = "X0" and ALUOp = '1' ) 
				 report "Not DP Imm" severity warning;
	end process;
	
	-- test for STR
	process ( STR_tested )
	begin 
		assert ( Branch = '0' and MemtoReg = 'X' and MemW = '1' and ALUSrc = '1' and 
				 ImmSrc = "01" and RegW = '0' and RegSrc = "10" and ALUOp = '0' ) 
				 report "Not STR" severity warning;
	end process;
	
	-- test for LDR
	process ( LDR_tested )
	begin 
		assert ( Branch = '0' and MemtoReg = '1' and MemW = '0' and ALUSrc = '1' and 
				 ImmSrc = "01" and RegW = '1' and RegSrc = "X0" and ALUOp = '0' ) 
				 report "Not LDR" severity warning;
	end process;
	
	-- test for B
	process ( B_tested )
	begin 
		assert ( Branch = '1' and MemtoReg = '0' and MemW = '0' and ALUSrc = '1' and 
				 ImmSrc = "10" and RegW = '0' and RegSrc = "X1" and ALUOp = '0' ) 
				 report "Not B" severity warning;
	end process;

end Behavioral;
