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

entity MAE is
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
end MAE;

architecture Behavioral of MAE is
  type STATE is (Idle, High, High_cont, Low, Low_cont, Fin_Trame, Delay);

  -- Signaux Internes
  signal EP, EF    : STATE;                 -- EP: Etat présent, EF: État Futur
  signal Cpt_Trame : integer range 0 to 51; -- Compteur pour la longeur du trame
begin

  Clk_Out <= Clk_Temp; -- Affectation du Port de Sortie

  -- Processus de Synchronisation du MAE
  sync : process (Clk, Reset)
  begin
    if (Reset = '0') then
      EP <= Idle;
    elsif (rising_edge(Clk)) then
      EP <= EF;
    end if;
  end process; -- Sync

  -- FSM state management
  FSM : process (EP, Fin_0, Fin_1, Fin_Tempo, DCC_in)
  begin
    case EP is
        -- Initial state
      when Idle =>
        if (DCC_in = '0') then
          EF <= Low;
        elsif (DCC_in = '1') then
          EF <= High;
        end if;

        -- Received a low bit
      when Low =>
        -- Next state
        EF <= Low_cont;
        -- Assign outputs
        Go_0      <= '1';           -- Start DCC bit generation
        Cpt_Trame <= Cpt_Trame + 1; -- Increment trame counter

        -- Wait until the bit has been transmitted
      when Low_cont =>
        -- Next state
        EF <= Low_cont;
        -- Reached the end of a frame?
        if (Cpt_Trame = 51) then
          EF <= Fin_Trame;
        end if;

        if (DCC_in = '0' and Fin_0 = '1') then
          EF        <= Low;
          Shift_DCC <= '1';
        elsif (DCC_in = '1' and Fin_0 = '1') then
          EF        <= High;
          Shift_DCC <= '1';
        end if;
        -- Assign outputs
        Go_0 <= '0';

        -- Received a high bit
      when High =>
        -- Next state
        EF <= High_cont;
        -- Assign outputs
        Go_1      <= '1';           -- Start DCC bit generation
        Cpt_Trame <= Cpt_Trame + 1; -- Increment trame counter

        -- Wait until the bit has been transmitted
      when High_cont =>
        -- Next state
        EF <= High_cont;
        -- Reached the end of a frame?
        if (Cpt_Trame = 51) then
          EF <= Fin_Trame;
        end if;

        if (DCC_in = '0' and Fin_1 = '1') then
          EF        <= Low;
          Shift_DCC <= '1';
        elsif (DCC_in = '1' and Fin_1 = '1') then
          EF        <= High;
          Shift_DCC <= '1';
        end if;
        -- Assign outputs
        Go_1 <= '0';

        -- End of frame, must wait 6 ms
      when Fin_Trame =>
        -- Next state
        EF <= Delay;
        -- Assign outputs
        Start_Tempo <= '1';
        Cpt_Trame   <= 0;

        -- Active waiting for 6 ms (interval between frames)
      when Delay =>
        -- Next state
        EF <= Delay;
        -- 6ms have passed, return to initial state
        if (Fin_Tempo = '1') then
          EF <= Idle;
        end if;
        -- Assign outputs
        Start_Tempo <= '0';
    end case;
  end process; -- MAE

end Behavioral;