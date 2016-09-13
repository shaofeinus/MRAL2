----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.09.2016 14:23:21
-- Design Name: 
-- Module Name: Decoder_PCLogic - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Decoder_PCLogic is
    Port ( Rd : in STD_LOGIC_VECTOR (3 downto 0);   -- from instruction memory
           Branch : in STD_LOGIC;                   -- from Decoder_MainDecoder 
           RegW : in STD_LOGIC;                     -- from Decoder_MainDecoder
           PCS : out STD_LOGIC);                    -- to CondLogic
end Decoder_PCLogic;

architecture Behavioral of Decoder_PCLogic is

begin

    PCS <= '1' when (Rd = "1111" and RegW = '1') or Branch = '1' else
           '0';

end Behavioral;
