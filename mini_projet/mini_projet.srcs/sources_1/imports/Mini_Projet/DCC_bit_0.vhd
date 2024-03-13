-- Note: Owen m'a dit qu'il commence à compter dans les états High et Low

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

entity DCC_bit_0 is
  port
  (
    Reset     : in std_logic;  -- Reset Asynchrone
    Clk       : in std_logic;  -- Horloge 100 MHz de la carte Nexys
    Tempo_clk : in std_logic;  -- Horloge 1 MHz donnée par Tempo
    Go        : in std_logic;  -- Signal de Validation
    Fin       : out std_logic; -- Signal de Fin
    DCC_Out   : out std_logic  -- Signal DCC de sortie
  );
end DCC_bit_0;

architecture Behavioral of DCC_bit_0 is
  constant MAX_COUNT : integer := 100; -- Signal period (100 microseconds)
  type STATE is (Idle, High, Low, Finished);

  -- Internal signals
  signal EP, EF  : STATE; -- EP: Etat présent, EF: État Futur
  signal Cpt     : integer range 0 to (MAX_COUNT - 1);
  signal Clk_DCC : std_logic;

begin

  -- Processus de Synchronisation du MAE
  sync : process (Clk, Reset)
  begin
    if (Reset = '0') then
      EP <= Idle;
    elsif (rising_edge(Clk)) then
      EP <= EF;
    end if;
  end process; -- Sync

  -- Processus de Comptage cadencé par l'horloge 1 MHz
  Count : process (Tempo_clk, Reset)
  begin
    if (Reset = '0') then
      Cpt <= 0;
      -- Clk_DCC <= '0';
    elsif (rising_edge(Tempo_clk)) then
      if Cpt = (MAX_COUNT - 1) then
        Cpt <= 0;
      else
        Cpt <= Cpt + 1;
        -- Clk_DCC <= not Clk_DCC;
      end if;
    end if;
  end process; -- Count

  -- Finite State Machine logic
  MAE : process (EP, Go, Clk_DCC)
  begin
    case EP is
      when Idle =>
        -- Next State Logic
        EF <= Idle;
        if (Go = '1') then
          EF <= Low;
        end if;
        -- Output Logic
        DCC_Out <= '0';
        Fin     <= '0';

      when Low =>
        -- Next State Logic
        EF <= Low;
        if (rising_edge(Clk_DCC)) then
          -- if (Clk_DCC = '1') then
          EF <= High;
        end if;
        -- Output Logic
        DCC_Out <= '0';
        Fin     <= '0';

      when High =>
        -- Next State Logic
        EF <= High;
        if (rising_edge(Clk_DCC)) then
          -- if (Clk_DCC = '1') then
          EF <= Finished;
        end if;
        -- Output Logic
        DCC_Out <= '1';
        Fin     <= '0';

      when Finished =>
        -- Next State Logic
        EF <= Idle;
        -- Output Logic
        DCC_Out <= '0';
        Fin     <= '1';

    end case;
  end process; -- MAE

  Clk_DCC <= '1' when (Cpt = (MAX_COUNT - 1)) else
    '0';

end Behavioral;