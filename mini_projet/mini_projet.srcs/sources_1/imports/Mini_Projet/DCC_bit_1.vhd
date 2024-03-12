library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

entity DCC_bit_1 is
  port
  (
    Reset    : in std_logic;  -- Reset Asynchrone
    Clk_In   : in std_logic;  -- Horloge 100 MHz de la carte Nexys
    Clk_1Mhz : in std_logic;  -- Horloge 1 MHz donnée par Tempo
    Go       : in std_logic;  -- Signal de Validation
    Fin      : out std_logic; -- Signal de Fin
    Start    : out std_logic  -- Signal DCC de sortie
  );
end DCC_bit_1;

architecture Behavioral of DCC_bit_1 is
  constant MAX_COUNT : integer := 100; -- Durée de la signal (100 microsecondes)
  type STATE is (Reset, Idle, High, Low, Fin);

  -- Signaux Internes
  signal EP, EF : STATE; -- EP: Etat présent, EF: État Futur
  signal Cpt    : natural range 0 to (MAX_COUNT - 1);
  signal Done   : std_logic;

begin

  Clk_Out <= Clk_Temp; -- Affectation du Port de Sortie

  -- Processus de Synchronisation du MAE
  sync : process (Clk_In, Reset)
  begin
    if (Reset = '0') then
      EP <= Reset;
    elsif (rising_edge(Clk_In)) then
      EP <= EF;
    end if;
  end process; -- Sync

  -- Processus de Comptage cadencé par l'horloge 1 MHz
  Count : process (Clk_1Mhz, Reset)
  begin
    if (Reset = '0') then
      Cpt <= 0;
    elsif (rising_edge(Clk_1Mhz)) then
      Cpt <= Cpt + 1;
    end if;
  end process; -- Sync

  -- Machine à État Fini
  MAE : process (EP, Go)
  begin
    case EP is
      when Reset =>
        EF   <= Idle;
        Done <= '0';

      when Idle =>
        EF <= Idle;
        if (Go = '1') then
          EF <= High;
        end if;
        Done <= '0';

      when High =>
        EF <= High;
        if (Done = '1') then
          EF   <= Low;
          Done <= '0';
        end if;

      when Low =>
        EF <= Fin;
      when Fin =>
        EF <= Idle;
    end case;
  end process;

end Behavioral;