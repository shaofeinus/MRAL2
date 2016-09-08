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
           Funct : in STD_LOGIC_VECTOR (5 downto 0);    -- from instruction memory
           Branch : out STD_LOGIC;                      -- to Decoder_PCLogic
           RegW : out STD_LOGIC;                        -- to CondLogic and Decoder_PCLogic
           MemW : out STD_LOGIC;                        -- to CondLogic
           MemtoReg : out STD_LOGIC;                    -- to mux in ARM (output of data memory)
           ALUSrc : out STD_LOGIC;                      -- to mux in ARM (input of ALU)
           ImmSrc : out STD_LOGIC_VECTOR (1 downto 0);  -- to Extend
           RegSrc : out STD_LOGIC_VECTOR (1 downto 0);  -- to mux in ARM (input of RegFile)
           ALUOp : out STD_LOGIC);                      -- to Decoder_ALUDecoder
end Decoder_MainDecoder;

architecture Behavioral of Decoder_MainDecoder is

begin


end Behavioral;
