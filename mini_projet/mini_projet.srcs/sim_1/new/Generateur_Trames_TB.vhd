----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.03.2024 12:13:55
-- Design Name: 
-- Module Name: Generateur_Trames_TB - Behavioral
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
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Generateur_Trames_TB is
end Generateur_Trames_TB;

architecture Behavioral of Generateur_Trames_TB is
signal Interrupteur	: STD_LOGIC_VECTOR(7 downto 0);
signal Trame_DCC: std_logic_vector(50 downto 0);

begin

l0: entity work.DCC_FRAME_GENERATOR
port map(Interrupteur=>Interrupteur,
        Trame_DCC=>Trame_DCC);

Interrupteur <= X"00", X"01" after 100 ns;

end Behavioral;
