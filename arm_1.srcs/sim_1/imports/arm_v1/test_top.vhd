----------------------------------------------------------------------------------
--	License terms :
--	You are free to use this code as long as you
--		(i) DO NOT post it on any public repository;
--		(ii) use it only for educational purposes;
--		(iii) accept the responsibility to ensure that your implementation does not violate any intellectual property of ARM Holdings or other entities.
--		(iv) accept that the program is provided "as is" without warranty of any kind or assurance regarding its suitability for any particular purpose;
--		(v) send an email to rajesh.panicker@ieee.org briefly mentioning its use (except when used for the course CG3207 at the National University of Singapore);
--		(vi) retain this notice in this file or any files derived from this.
----------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY test_top IS
END test_top;
 
ARCHITECTURE behavior OF test_top IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT TOP
    PORT(
         DIP : IN  std_logic_vector(15 downto 0);
         PB : IN  std_logic_vector(3 downto 0);
         LED : OUT  std_logic_vector(15 downto 0);
         TX : OUT  std_logic;
         RX : IN  std_logic;
         PAUSE : IN  std_logic;
         RESET : IN  std_logic;
         CLK_undiv : IN  std_logic
        );
    END COMPONENT;

   --Inputs
   signal DIP : std_logic_vector(15 downto 0) := (others => '0');
   signal PB : std_logic_vector(3 downto 0) := (others => '0');
   signal RX : std_logic := '0';
   signal PAUSE : std_logic := '0';
   signal RESET : std_logic := '0';
   signal CLK_undiv : std_logic := '0';

 	--Outputs
   signal LED : std_logic_vector(15 downto 0);
   signal TX : std_logic;

   -- Clock period definitions
   constant CLK_undiv_period : time := 10 ns;
   
   -- Signals for better visibility
   signal PC_value : std_logic_vector(6 downto 0);
   signal LED_value : std_logic_vector(7 downto 0);
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: TOP PORT MAP (
          DIP => DIP,
          PB => PB,
          LED => LED,
          TX => TX,
          RX => RX,
          PAUSE => PAUSE,
          RESET => RESET,
          CLK_undiv => CLK_undiv
        );

   -- Clock process definitions
   CLK_undiv_process :process
   begin
		CLK_undiv <= '0';
		wait for CLK_undiv_period/2;
		CLK_undiv <= '1';
		wait for CLK_undiv_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 10 ns.
      wait for 10 ns;
	  RESET <= '1';                                     --RESET is ACTIVE LOW
	  
	  -- Simulation for DP with no shift
--	  DIP <= x"0001"; PB <= "0001"; wait for 500ns;    -- ADD
--	  DIP <= x"0001"; PB <= "0010"; wait for 500ns;    -- SUB
--	  DIP <= x"0000"; PB <= "0100"; wait for 500ns;    -- ORR
--	  DIP <= x"0000"; PB <= "1000"; wait for 500ns;    -- AND

      -- Simulation for Memory with offset
--      DIP <= x"F000"; PB <= "0010"; wait for 1us;    -- STR (positive offset) 0xF0 
--                                                       -- @ (Ref addr: 0x880 + Base addr: 0x00 + Offset: 16 = 0x890)
--      DIP <= x"0F80"; PB <= "0100"; wait for 1us;    -- STR (negative offset) 0x0F
--                                                       -- @ (Ref addr: 0x880 + Base addr: 0x80 - Offset: 16 = 0x8F0)
--      DIP <= x"0020"; PB <= "0001"; wait for 1us;    -- LDR (negative offset) 
--                                                       -- @ (Ref addr: 0x880 + Base addr: 0x20 - Offset: 16 = 0x890)
--      DIP <= x"0060"; PB <= "1000"; wait for 1us;    -- LDR (positive offset) 
--                                                       -- @ (Ref addr: 0x880 + Base addr: 0x60 + Offset: 16 = 0x8F0)

      -- Simulation for Counter
      DIP <= x"000F"; PB <= "0001"; wait for 10us;         -- unsigned count down
      DIP <= x"00F0"; PB <= "1000"; wait for 10us;         -- unsigned count up
      DIP <= x"008F"; PB <= "0100"; wait for 10us;         -- signed count down, stop counting down when 0x00 is reached 
      DIP <= x"0070"; PB <= "0010"; wait for 10us;         -- signed count up, stop counting up when 0x00 is reached
      DIP <= x"0007"; PB <= "0100"; wait for 10us;         -- signed count down, continue counting down when 0x00 is reached
      DIP <= x"00F8"; PB <= "0010"; wait for 10us;         -- signed count up, continue counting up when 0x00 is reach
      
   end process;
   
   -- Dispaly PC value as a signal
   PC_value <= LED(6 downto 0);
   -- Display Register value in regfile as signal 
   LED_value <= LED(15 downto 8);

END;
