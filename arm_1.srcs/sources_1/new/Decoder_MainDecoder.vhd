----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.09.2016 14:23:21
-- Design Name: 
-- Module Name: Decoder_MainDecoder - Behavioral
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

entity Decoder_MainDecoder is
    Port ( Op : in STD_LOGIC_VECTOR (1 downto 0);       -- from instruction memory 
           Funct5 : in STD_LOGIC;                       -- from instruction memory
           Funct0 : in STD_LOGIC;                       -- from instruction memory
           Branch : out STD_LOGIC;                      -- to Decoder_PCLogic
           RegW : out STD_LOGIC;                        -- to CondLogic and Decoder_PCLogic
           MemW : out STD_LOGIC;                        -- to CondLogic
           MemtoReg : out STD_LOGIC;                    -- to mux in ARM (output of data memory)
           ALUSrc : out STD_LOGIC;                      -- to mux in ARM (input of ALU)
           ImmSrc : out STD_LOGIC_VECTOR (1 downto 0);  -- to Extend
           RegSrc : out STD_LOGIC_VECTOR (1 downto 0);  -- to mux in ARM (input of RegFile)
           ALUOp : out STD_LOGIC_VECTOR (1 downto 0));  -- to Decoder_ALUDecoder
end Decoder_MainDecoder;

architecture Behavioral of Decoder_MainDecoder is

begin
	
	-- Refer to Lecture 3 p48
	
    Branch      <=      '1' when Op = "10" else
						'0' when Op = "00" or Op = "01" else
                        'X';
						
    MemtoReg    <=    	'1' when Op = "01" and Funct0 = '1' else
						'0' when Op = "00" or (Op = "01" and Funct0 = '1') or Op = "10" else
                        'X';
	
	MemW		<=		'1' when Op = "01" and Funct0 = '0' else
						'0' when Op = "00" or (Op = "01" and Funct0 = '1') or Op = "10" else
						'X';
								
	ALUSrc      <=      '0' when Op = "00" and Funct5 = '0' else 
						'1' when (Op = "00" and Funct5 = '1') or Op = "01" or Op = "10" else 
						'X';
	
	ImmSrc		<=		"00" when Op = "00" and Funct5 = '1' else
						"01" when Op = "01" else
						"10" when Op = "10" else
						"XX" when Op = "00" and Funct5 = '0' else
						"XX";
	
	RegW		<=		'1' when Op = "00" or (Op = "01" and Funct0 = '1') else
						'0' when (Op = "01" and Funct0 = '0') or Op = "10" else
						'X';
	
	RegSrc		<=		"00" when Op = "00" and Funct5 = '0' else
						"10" when Op = "01" and Funct0 = '0' else
						"X0" when (Op = "00" and Funct5 = '1') or (Op = "01" and Funct0 = '1') else
						"X1" when Op = "10" else
						"XX";
	
	ALUOp		<=		"00" when Op = "10" else	-- B (although ALUOp = "00", ALU still does an add operation which is always expected by B instr)
						"01" when Op = "00" else	-- ADD, SUB, AND, OR, CMP
						"10" when Op = "01" else	-- LDR/STR (ALUOp = "10" tells the ALU decoder look at the U bit to decide whether to do add or sub operation)
						"XX";

end Behavioral;
