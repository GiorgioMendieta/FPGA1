library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity COMPTEUR_TEMPO_tb is
  -- empty
end COMPTEUR_TEMPO_tb;

architecture testbench of COMPTEUR_TEMPO_tb is

  component COMPTEUR_TEMPO is
    port
    (
      Clk         : in std_logic; -- Horloge 100 MHz
      Reset       : in std_logic; -- Reset Asynchrone
      Clk1M       : in std_logic; -- Horloge 1 MHz
      Start_Tempo : in std_logic; -- Commande de D�marrage de la Temporisation
      Fin_Tempo   : out std_logic -- Drapeau de Fin de la Temporisation
    );
  end component;

  signal Clk_s         : std_logic;
  signal Reset_s       : std_logic;
  signal Clk1M_s       : std_logic;
  signal Start_Tempo_s : std_logic;
  signal Fin_Tempo_s   : std_logic;

  -- Clock period definitions
  constant clk_period      : time := 1 ps; -- 10us
  constant clk_period_1MHz : time := 2 ps; -- 1000us

begin

  DUT : COMPTEUR_TEMPO port map
  (
    Clk         => Clk_s,
    Reset       => Reset_s,
    Clk1M       => Clk1M_s,
    Start_Tempo => Start_Tempo_s,
    Fin_Tempo   => Fin_Tempo_s
  );

  clk_process1 : process
  begin
    Clk_s <= '0';
    wait for clk_period/2;
    Clk_s <= '1';
    wait for clk_period/2;
  end process;

  clk_process2 : process
  begin
    Clk1M_s <= '0';
    wait for clk_period_1MHz/2;
    Clk1M_s <= '1';
    wait for clk_period_1MHz/2;
  end process;

  stim_proc : process
  begin

    Reset_s       <= '1';
    Start_Tempo_s <= '0';

    wait for clk_period;

    Reset_s <= '0';

    wait for clk_period * 100;

    Start_Tempo_s <= '1';
    wait for clk_period * 100;

    -- Start_Tempo_s <= '0';
    wait for clk_period * 100;

    wait;
  end process;

end testbench;