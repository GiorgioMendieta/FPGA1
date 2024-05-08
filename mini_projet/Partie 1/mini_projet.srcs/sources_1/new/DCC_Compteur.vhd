----------------------------------------------------------------------------------
-- Company: Sorbonne Universite 
-- Engineer: Youba FERHOUNE & Giorge Mendieta
-- 
-- Create Date: 12.03.2024 12:16:19
-- Design Name: 
-- Module Name:
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity DCC_Compteur is
  port
  (
    Clk1M : in std_logic; -- Horloge 1 MHz
    Reset : in std_logic; -- Reset Asynchrone
    Cmd   : in std_logic; -- Counting or not 1/0
    Seuil : in integer;   -- Seuil for the counter
    Fin   : out std_logic -- Finish counting or not 
  );
end DCC_Compteur;

architecture Behavioral of DCC_Compteur is

  -- Counter
  signal cpt : integer;

begin

  process (Clk1M, Reset)
  begin
    if Reset = '1' then
      cpt <= 0; -- Reset counter
    elsif rising_edge(Clk1M) then
      if Cmd = '1' then -- if Cmd is to count and not in reset mode
        cpt <= cpt + 1;   -- cpt ++
      end if;
    end if;
  end process;

  --  Output signal
  Fin <= '1' when cpt = Seuil else
    '0';
end Behavioral;