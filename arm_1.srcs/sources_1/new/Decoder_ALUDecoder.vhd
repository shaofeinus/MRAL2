----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.09.2016 14:23:21
-- Design Name: 
-- Module Name: Decoder_ALUDecoder - Behavioral
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

entity Decoder_ALUDecoder is
    Port ( Funct : in STD_LOGIC_VECTOR (4 downto 0);        -- from instruction memory
           ALUOp : in STD_LOGIC_VECTOR (1 downto 0);        -- from Decoder_MainDecoder
           ALUControl : out STD_LOGIC_VECTOR (1 downto 0);  -- to ALU
           FlagW : out STD_LOGIC_VECTOR (1 downto 0);       -- to CondLogic
           NoWrite : out STD_LOGIC );                       -- to CondLogic
end Decoder_ALUDecoder;

architecture Behavioral of Decoder_ALUDecoder is

begin

	-- Refer to Lecture 3 p43
	
	ALUControl		<=		"00" when
								-- non ALU op --
								( ALUOp = "00" )
								or 
								-- add --
								( ALUOp = "01" and Funct( 4 downto 1 ) = "0100" )
								or
								-- STR/LDR with positive Imm offset --
								( ALUOp = "10" and Funct(3) = '1' ) else
							"01" when 
							    -- sub --
								( ALUOp = "01" and Funct( 4 downto 1 ) = "0010" ) 
								or
								-- cmp --
								( ALUOp = "01" and Funct( 4 downto 1 ) = "1010" and Funct(0) = '1' )	
								or
								-- STR/LDR with negative Imm offset --
								( ALUOp = "10" and Funct(3) = '0' ) else
							"10" when 
								-- and --
								( ALUOp = "01" and Funct( 4 downto 1 ) = "0000" ) else
							"11" when 
								-- orr --
								( ALUOp = "01" and Funct( 4 downto 1 ) = "1100" ) else
							"XX";
	
	FlagW			<=		"00" when
								-- non ALU op, STR/LDR --
								( ALUOp = "00" or  ALUOp = "10" ) 
								or
								-- add, sub, and, orr with S = 0
								( ALUOp = "01" and 
								( Funct( 4 downto 1 ) = "0100" or
								  Funct( 4 downto 1 ) = "0010" or
								  Funct( 4 downto 1 ) = "0000" or
								  Funct( 4 downto 1 ) = "1100" ) and Funct(0) = '0' ) else 
							"11" when
								-- add, sub with S = 1--
								( ALUOp = "01" and 
								( Funct( 4 downto 1 ) = "0100" or
								  Funct( 4 downto 1 ) = "0010" ) and Funct(0) = '1' )							  
								or 
								-- cmp --
								( ALUOp = "01" and Funct( 4 downto 1 ) = "1010" and Funct(0) = '1' ) else
							"10" when
								-- and, or with S = 1
								( ALUOp = "01" and 
								( Funct( 4 downto 1 ) = "0000" or
								  Funct( 4 downto 1 ) = "1100" ) and Funct(0) = '1' ) else
							"XX";
	
	NoWrite			<= 		'0' when 
								-- non ALU op, STR/LDR --
								( ALUOp = "00" or ALUOp = "10") 
								or
								-- add, sub, and, orr--
								( ALUOp = "01" and 
								( Funct( 4 downto 1 ) = "0100" or
								  Funct( 4 downto 1 ) = "0010" or
								  Funct( 4 downto 1 ) = "0000" or
								  Funct( 4 downto 1 ) = "1100" )) else
							'1' when 
								-- cmp --
								( ALUOp = "01" and Funct( 4 downto 1 ) = "1010" and Funct(0) = '1' ) else
							'X';

end Behavioral;
