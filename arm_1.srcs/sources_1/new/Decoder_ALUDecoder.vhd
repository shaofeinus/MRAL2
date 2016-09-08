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
           ALUOp : in STD_LOGIC;                            -- from Decoder_MainDecoder
           ALUControl : out STD_LOGIC_VECTOR (1 downto 0);  -- to ALU
           FlagW : out STD_LOGIC_VECTOR (1 downto 0);       -- to CondLogic
           NoWrite : out STD_LOGIC );                       -- to CondLogic
end Decoder_ALUDecoder;

architecture Behavioral of Decoder_ALUDecoder is

begin


end Behavioral;
