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
    Clk1M       : in std_logic; -- Horloge 1 
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
  type STATE is (Idle, Load, Shift, High, High_Count, Low, Low_Count, Fin, Fin_Count);

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
  FSM : process (EP, Fin_0, Fin_1, Fin_Tempo, Cpt_Trame, DCC_in)
  begin
    case EP is
        -- Initial state
      when Idle =>
            EF <= Load;            
             -- Assign outputs
        Go_0        <= '0';
        Go_1        <= '0';
        Shift_DCC   <= '0';
        Load_DCC    <= '0';
        Start_Tempo <= '0';
        
      when Load =>
           EF <= Shift;
        -- Assign outputs
        Go_0        <= '0';
        Go_1        <= '0';
        Shift_DCC   <= '0';
        Load_DCC    <= '1';
        Start_Tempo <= '0';
        
       -- Shift -----------------------------------------------------------------------
      when Shift =>  
        -- Next state
        if DCC_in = '0' then               
            EF <= Low;              
        elsif  DCC_in = '1' then              
            EF <= High;  
        else
            EF <= Load;                 
        end if;
        
        -- Assign outputs
        Go_0        <= '0';
        Go_1        <= '0';
        Load_DCC    <= '0';
        Shift_DCC   <= '1';
        Start_Tempo <= '0';

        -- Received a low bit --------------------------------------------------------------------------
      when Low =>
        -- Next state
        EF <= Low_Count;
        
       -- Received a low bit --------------------------------------------------------------------------
      when Low_Count =>
        -- Next state
        EF <= Low_Count;
        
        if (Fin_0 = '1') then
            if (Cpt_Trame = 51) then
                EF <= Fin;
            else
                EF <= Shift;
            end if;
        end if;
        -- Assign outputs
        Go_0        <= '1';           -- Start DCC bit generation
        Go_1        <= '0';
        Shift_DCC   <= '0';
        Load_DCC    <= '0';
        Start_Tempo <= '0';

        -- Received a high bit --------------------------------------------------------------------------------------------
      when High =>
        -- Next state
        EF <= High_Count;

       -- Received a high bit --------------------------------------------------------------------------------------------
      when High_Count =>
        -- Next state          
        if (Fin_1 = '1') then
            if (Cpt_Trame = 51) then
                EF <= Fin;
            else
                EF <= Shift;
            end if;
        else
            EF <= High_Count;
        end if;
        -- Assign outputs
        Go_0        <= '0';
        Go_1        <= '1';           -- Start DCC bit 
        Load_DCC    <= '0';
        Shift_DCC   <= '0';
        Start_Tempo <= '0';

        -- End of frame, must wait 6 ms ----------------------------------------------------------------------------------------
      when Fin =>
         EF <= Fin_Count;     

      when Fin_Count =>
        -- Next state
        -- 6ms have passed, return to initial state
        if (Fin_Tempo = '1') then
          EF <= Idle;
        else 
            EF <= Fin_Count; 
        end if;
        -- Assign outputs
        Go_0        <= '0';
        Go_1        <= '0';
        Load_DCC    <= '0';
        Shift_DCC   <= '0';
        Start_Tempo <= '1';
    end case;
  end process; -- MAE
  
   process(clk,reset)
        begin
            if reset = '1' then Cpt_Trame <= 0;
            elsif rising_edge(clk) then
                case (EP) is
                    when Idle   => Cpt_Trame <= 0;
                    when Shift  => Cpt_Trame <= Cpt_Trame + 1;
                    when Fin    => Cpt_Trame <= 0;
                    when others => null;
                end case;
            end if;
        end process;
  

end Behavioral;