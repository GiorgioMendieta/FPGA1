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
    Load_DCC    : out std_logic; -- Signal pour charger la trame DCC
    Shift_DCC   : out std_logic  -- Signal pour décaler le bit DCC
  );
end MAE;

architecture Behavioral of MAE is
  type STATE is (Idle, High, High_cont, Low, Low_cont, Fin_Trame);

  -- Internal Signals
  signal EP, EF    : STATE;                 -- EP: Etat présent, EF: État Futur
  signal Cpt_Trame : integer range 0 to 51; -- Frame length counter
begin

  -- Synchronization of the FSM
  sync : process (Clk, Reset)
  begin
    if (Reset = '1') then
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
        -- Next state
        if (DCC_in = '0') then
          EF <= Low;
        elsif (DCC_in = '1') then
          EF <= High;
        end if;
        -- Assign outputs
        Go_0        <= '0';
        Go_1        <= '0';
        Shift_DCC   <= '0';
        Load_DCC    <= '1';
        Start_Tempo <= '0';

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
          EF <= Low;
        elsif (DCC_in = '1' and Fin_0 = '1') then
          EF <= High;
        end if;
        -- Assign outputs
        Go_0      <= '0';
        Load_DCC  <= '0';
        Shift_DCC <= '1';

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
          EF <= Low;
        elsif (DCC_in = '1' and Fin_1 = '1') then
          EF <= High;
        end if;
        -- Assign outputs
        Go_1      <= '0';
        Load_DCC  <= '0';
        Shift_DCC <= '1';

        -- End of frame, must wait 6 ms
      when Fin_Trame =>
        -- Next state
        EF <= Fin_Trame;
        -- 6ms have passed, return to initial state
        if (Fin_Tempo = '1') then
          EF <= Idle;
        end if;
        -- Assign outputs
        Start_Tempo <= '1';
        Cpt_Trame   <= 0;
    end case;
  end process; -- MAE

end Behavioral;