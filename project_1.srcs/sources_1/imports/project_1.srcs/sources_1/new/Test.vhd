----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 22.01.2024 08:57:16
-- Design Name: 
-- Module Name: Test - Behavioral
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

entity Test is
    Port ( SW2 : in STD_LOGIC;
           SW1 : in STD_LOGIC;
           SW0 : in STD_LOGIC;
           LED : out STD_LOGIC_VECTOR (2 downto 0));
end Test;

architecture Behavioral of Test is

begin

    LED(0) <= SW0;
    LED(1) <= SW1;
    LED(2) <= SW0 AND SW1 AND SW2;
    
end Behavioral;
