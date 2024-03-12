----------------------------------------------------------------------------------
-- Company: 
-- Designed by: 
--
-- Module Name: MAE_top - Behavioral
-- Project Name: Centrale DCC
-- Target Devices: NEXYS 4 DDR
--
-- Generates DCC frames and spaces them by 6ms
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

entity MAE_top is
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
    Shift_DCC   : out std_logic; -- Signal pour décaler le bit DCC
  );
end MAE_top;

architecture Behavioral of MAE_top is
  type STATE is (Reset, Idle, Bit_1, Bit_0, Fin_Trame);

  -- Signaux Internes
  signal EP, EF    : STATE;                 -- EP: Etat présent, EF: État Futur
  signal Cpt_Trame : integer range 0 to 51; -- Compteur pour la longeur du trame
begin

  Clk_Out <= Clk_Temp; -- Affectation du Port de Sortie

  -- Processus de Synchronisation du MAE
  sync : process (Clk, Reset)
  begin
    if (Reset = '0') then
      EP <= Reset;
    elsif (rising_edge(Clk)) then
      EP <= EF;
    end if;
  end process; -- Sync

  -- Machine à État Fini
  MAE : process (EP, Fin_0, Fin_1, Fin_Tempo)
  begin
    case EP is
      when Idle =>
        if (DCC_in = '0') then
          EF <= Bit_0;
        elsif (DCC_in = '1') then
          EF <= Bit_1;
        end if;

      when Bit_0 =>
        -- Next state
        EF <= Bit_0_cont;
        -- Assign outputs
        Go_0      <= '1';
        Cpt_Trame <= Cpt_Trame + 1;

      when Bit_0_cont =>
        -- Next state
        EF <= Bit_0_cont;
        -- Atteint la fin d'une trame avec deux commandes ?
        if (Cpt_Trame = 51) then
          EF        <= Fin_Trame;
          Cpt_Trame <= 0;
        end if;
        if (DCC_in = '0' and Fin_1 = '1') then
          EF        <= Bit_0;
          Shift_DCC <= '1';
        elsif (DCC_in = '1' and Fin_1 = '1') then
          EF        <= Bit_1;
          Shift_DCC <= '1';
        end if;
        -- Assign outputs
        Go_0 <= '0';

      when Fin_Trame =>
        -- Next state
        EF <= Fin_Trame_cont;
        -- Assign outputs
        Start_Tempo <= '1';

      when Fin_Trame_cont =>
        -- Next state
        EF <= Fin_Trame_cont;
        if (Fin_Tempo = '1') then
          EF <= Idle;
        end if;
        -- Assign outputs
        Start_Tempo <= '0';

    end case;
  end process; -- MAE

end Behavioral;