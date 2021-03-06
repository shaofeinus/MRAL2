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
 
ENTITY test_top_counter IS
END test_top_counter;
 
ARCHITECTURE behavior OF test_top_counter IS 
 
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
 
   -- Test bench for Counter.s
   -- Remember to uncomment the Instruction and Data memory section 
   -- for Counter.s in TOP.vhd before simulation
   -- IMPORTANT: Use the delay value of 0x00000002 in ROM of TOP.vhd. 
   -- Refer Instruction and Data memory for Counter.s in TOP.vhd for details.
   stim_proc: process
   begin		
      -- hold reset state for 10 ns.
      wait for 10 ns;
	  RESET <= '1';                                     --RESET is ACTIVE LOW
	 
      -- Simulation for Counter
      DIP <= x"0001"; PB <= "1000"; wait for 10us;         -- unsigned count up, stop counting down when 0xF1 is reached 
      PB <= "0000"; wait for 5us;
      DIP <= x"00F1"; PB <= "0001"; wait for 10us;         -- unsigned count down, stop counting down when 0x01 is reached 
      PB <= "0000"; wait for 5us;
      DIP <= x"00F1"; PB <= "0010"; wait for 10us;         -- signed count up, stop counting up when 0x71 is reached
      PB <= "0000"; wait for 5us;
      DIP <= x"0001"; PB <= "0100"; wait for 10us;         -- signed count down, stop counting down when 0x81 is reached 
      PB <= "0000"; wait for 5us;
      
      DIP <= x"0021"; PB <= "1000"; wait for 10us;         -- unsigned count up, stop counting down when 0xF1 is reached 
      PB <= "0000"; wait for 5us;
      DIP <= x"00A1"; PB <= "0001"; wait for 10us;         -- unsigned count down, stop counting down when 0x01 is reached 
      PB <= "0000"; wait for 5us;
      DIP <= x"0051"; PB <= "0010"; wait for 10us;         -- signed count up, stop counting up when 0x71 is reached
      PB <= "0000"; wait for 5us;
      DIP <= x"0011"; PB <= "0100"; wait for 10us;         -- signed count down, stop counting down when 0x81 is reached 
      PB <= "0000"; wait for 5us;   
   end process;
   
   -- Dispaly PC value as a signal
   PC_value <= LED(6 downto 0);
   -- Display Register value in regfile as signal 
   LED_value <= LED(15 downto 8);

END;
