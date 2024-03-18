----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 18.03.2024 09:50:41
-- Design Name: 
-- Module Name: Top_DCC_TB - Behavioral
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

entity Top_DCC_TB is
  --  Port ( );
end Top_DCC_TB;

architecture Behavioral of Top_DCC_TB is
  signal Interrupteur : std_logic_vector(7 downto 0);
  signal clk          : std_logic := '0';
  signal reset        : std_logic;

begin
  l0 : entity work.Top_DCC
    port map
    (
      Interrupteur => Interrupteur,
      clk          => clk,
      reset        => reset
    );
  );
  Clk          <= not Clk after 5 ns;
  Reset        <= '1', '0' after 2 ns;
  Interrupteur <= X"00", X"01" after 500 ns;