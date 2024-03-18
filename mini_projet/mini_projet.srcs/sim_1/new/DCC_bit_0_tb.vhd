library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DCC_bit_0_tb is
  --empty
end DCC_bit_0_tb;

architecture testbench of DCC_bit_0_tb is

  component DCC_bit_0 is
    port
    (
      Reset     : in std_logic;  -- Reset Asynchrone
      Clk       : in std_logic;  -- Horloge 100 MHz de la carte Nexys
      Tempo_clk : in std_logic;  -- Horloge 1 MHz donnée par Tempo
      Go        : in std_logic;  -- Signal de Validation
      Fin       : out std_logic; -- Signal de Fin
      DCC_Out   : out std_logic  -- Signal DCC de sortie
    );
  end component;

  -- Signal definitions
  signal Reset_s     : std_logic;
  signal Clk         : std_logic;
  signal Tempo_clk_s : std_logic;
  signal Go_s        : std_logic;
  signal Fin_s       : std_logic;
  signal DCC_Out_s   : std_logic;

  -- Clock period definitions
  constant DCC_period      : integer := 100;    -- Signal period (100 microseconds)
  constant clk_period      : time    := 1 ps;   -- 10us
  constant clk_period_1MHz : time    := 100 ps; -- 1000us

begin

  DUT : DCC_bit_0 port map
  (
    Reset     => Reset_s,
    Clk       => Clk,
    Tempo_clk => Tempo_clk_s,
    Go        => Go_s,
    Fin       => Fin_s,
    DCC_Out   => DCC_Out_s
  );

  clk_process1 : process
  begin
    Clk <= '0';
    wait for clk_period/2;
    Clk <= '1';
    wait for clk_period/2;
  end process;

  clk_process2 : process
  begin
    Tempo_clk_s <= '0';
    wait for clk_period_1MHz/2;
    Tempo_clk_s <= '1';
    wait for clk_period_1MHz/2;
  end process;

  stim_proc : process
  begin

    -- Test Reset
    report "--- DCC bit generation (0-bit) ---" severity note;
      Reset_s <= '0';
    Go_s    <= '0'; -- Signal de Validation

    wait for clk_period;
    assert (DCC_Out_s = '0') report "DCC value should be 0 during reset" severity error;

    -----
    Reset_s <= '1';
    Go_s    <= '0'; -- Signal de Validation

    wait for clk_period;

    Go_s <= '1'; -- Signal de Validation

    wait for clk_period_1MHz * DCC_period;
    assert (DCC_Out_s = '1') report "Invalid DCC out" severity error;

    wait for clk_period_1MHz * DCC_period;
    assert (DCC_Out_s = '0') report "Invalid DCC out" severity error;

    wait;
  end process;
end testbench;