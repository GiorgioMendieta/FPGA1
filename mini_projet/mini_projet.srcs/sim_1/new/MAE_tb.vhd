----------------------------------------------------------------------------------
-- Company: 
-- Designed by: 
--
-- Module Name: MAE - Behavioral
-- Project Name: Centrale DCC
-- Target Devices: NEXYS 4 DDR
--
-- Generates DCC frames and spaces them by 6ms
-- Note: The DCC frame is big endian, so the first bit is the most significant bit
-- This means frames will always start with the preambule (14 bits of 1s) 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

entity MAE_tb is
  --empty
end MAE_tb;

architecture testbench of MAE_tb is

  component MAE is
    port
    (
      Reset       : in std_logic;  -- Reset Asynchrone
      Clk         : in std_logic;  -- Horloge 100 MHz de la carte Nexys
      Go_0        : out std_logic; -- Signal pour générer le bit 0
      Go_1        : out std_logic; -- Signal pour générer le bit 1
      Fin_0       : in std_logic;  -- Signal de Fin du bit 0
      Fin_1       : in std_logic;  -- Signal de Fin du bit 1
      Start_Tempo : out std_logic; -- Signal pour démarrer le compteur
      Fin_Tempo   : in std_logic;  -- Signal pour arrêter le compteur
      DCC_in      : in std_logic;  -- Signal pour charger le bit DCC
      Load_DCC    : out std_logic; -- Signal pour charger la trame DCC
      Shift_DCC   : out std_logic  -- Signal pour décaler le bit DCC
    );
  end component;

  -- Signal definitions
  type STATE is (Idle, High, High_cont, Low, Low_cont, Fin_Trame, Delay);

  signal Reset_s       : std_logic;
  signal Clk_s         : std_logic;
  signal Go_0_s        : std_logic;
  signal Go_1_s        : std_logic;
  signal Fin_0_s       : std_logic;
  signal Fin_1_s       : std_logic;
  signal Start_Tempo_s : std_logic;
  signal Fin_Tempo_s   : std_logic;
  signal DCC_in_s      : std_logic;
  signal Load_DCC_s    : std_logic;
  signal Shift_DCC_s   : std_logic;

  -- Clock period definitions
  constant clk_period : time := 100 ps; -- 10us

begin

  DUT : MAE port map
  (
    Reset       => Reset_s,
    Clk         => Clk_s,
    Go_0        => Go_0_s,
    Go_1        => Go_1_s,
    Fin_0       => Fin_0_s,
    Fin_1       => Fin_1_s,
    Start_Tempo => Start_Tempo_s,
    Fin_Tempo   => Fin_Tempo_s,
    DCC_in      => DCC_in_s,
    Load_DCC    => Load_DCC_s,
    Shift_DCC   => Shift_DCC_s
  );

  clk_process : process
  begin
    Clk_s <= '0';
    wait for clk_period/2;
    Clk_s <= '1';
    wait for clk_period/2;
  end process;

  stim_proc : process
  begin
    report "--- MAE test bench ---" severity note;
      Reset_s     <= '0';
    Fin_0_s     <= '0';
    Fin_1_s     <= '0';
    Fin_Tempo_s <= '0';
    DCC_in_s    <= '0';

    wait for clk_period;

    Reset_s <= '1';
    wait for clk_period;

    -- Count 51 bits
    boucle : for i in 0 to 25 loop
      -- Bit 0
      Fin_0_s <= '1';
      wait for clk_period * 2;
      Fin_0_s <= '0';
      wait for clk_period * 2;
      -- Bit 1
      Fin_1_s <= '1';
      wait for clk_period * 2;
      Fin_1_s <= '0';
      wait for clk_period * 2;
    end loop; -- loop

    wait;
  end process;
end testbench;