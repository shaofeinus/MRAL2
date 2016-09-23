----------------------------------------------------------------------------------
-- Company: NUS	
-- Engineer: Rajesh Panicker
-- 
-- Create Date: 09/23/2015 06:49:10 PM
-- Module Name: Decoder
-- Project Name: CG3207 Project
-- Target Devices: Nexys 4 (Artix 7 100T)
-- Tool Versions: Vivado 2015.2
-- Description: Decoder Module
-- 
-- Dependencies: NIL
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

----------------------------------------------------------------------------------
--	License terms :
--	You are free to use this code as long as you
--		(i) DO NOT post it on any public repository;
--		(ii) use it only for educational purposes;
--		(iii) accept the responsibility to ensure that your implementation does not violate any intellectual property of ARM Holdings or other entities.
--		(iv) accept that the program is provided "as is" without warranty of any kind or assurance regarding its suitability for any particular purpose;
--		(v)	acknowledge that the program was written based on the microarchitecture described in the book Digital Design and Computer Architecture, ARM Edition by Harris and Harris;
--		(vi) send an email to rajesh.panicker@ieee.org briefly mentioning its use (except when used for the course CG3207 at the National University of Singapore);
--		(vii) retain this notice in this file or any files derived from this.
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Decoder is port(
			Rd			: in 	std_logic_vector(3 downto 0);
			Op			: in 	std_logic_vector(1 downto 0);
			Funct		: in 	std_logic_vector(5 downto 0);
			PCS			: out	std_logic;
			RegW		: out	std_logic;
			MemW		: out	std_logic;
			MemtoReg	: out	std_logic;
			ALUSrc		: out	std_logic;
			ImmSrc		: out	std_logic_vector(1 downto 0);
			RegSrc		: out	std_logic_vector(1 downto 0);
			NoWrite		: out	std_logic;                            -- for CMP instruction
			ALUControl	: out	std_logic_vector(1 downto 0);
			FlagW		: out	std_logic_vector(1 downto 0)
			);
end Decoder;

architecture Decoder_arch of Decoder is

	signal ALUOp 			: std_logic_vector (1 downto 0);
	signal Branch 			: std_logic;
	signal RegWTemp         : std_logic;
	
	component Decoder_PCLogic is
        Port ( Rd : in STD_LOGIC_VECTOR (3 downto 0);       -- from instruction memory
               Branch : in STD_LOGIC;                       -- from Decoder_MainDecoder 
               RegW : in STD_LOGIC;                         -- from Decoder_MainDecoder
               PCS : out STD_LOGIC);                        -- to CondLogic
    end component;
    
    component Decoder_MainDecoder is
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
    end component;
    
    component Decoder_ALUDecoder is
        Port ( Funct : in STD_LOGIC_VECTOR (4 downto 0);        -- from instruction memory
               ALUOp : in STD_LOGIC_VECTOR (1 downto 0);        -- from Decoder_MainDecoder
               ALUControl : out STD_LOGIC_VECTOR (1 downto 0);  -- to ALU
               FlagW : out STD_LOGIC_VECTOR (1 downto 0);       -- to CondLogic
               NoWrite : out STD_LOGIC );
    end component;
    
begin
    
    RegW <= RegWTemp;
    
    PCLogic : Decoder_PCLogic port map (
        Rd          => Rd,                    
        Branch      => Branch,                     
        RegW        => RegWTemp,                        
        PCS         => PCS );
    
    MainDecoder : Decoder_MainDecoder port map (
        Op          => Op,
        Funct5      => Funct(5),
        Funct0      => Funct(0),
        Branch      => Branch,
        RegW        => RegWTemp,
        MemW        => MemW,
        MemtoReg    => MemtoReg,
        ALUSrc      => ALUSrc,
        ImmSrc      => ImmSrc,
        RegSrc      => RegSrc,
        ALUOp       => ALUOp );
        
    ALUDecoder : Decoder_ALUDecoder port map (
        Funct       => Funct(4 downto 0),
        ALUOp       => ALUOp,
        ALUControl  => ALUControl,
        FlagW       => FlagW, 
        NoWrite     => NoWrite );

end Decoder_arch;