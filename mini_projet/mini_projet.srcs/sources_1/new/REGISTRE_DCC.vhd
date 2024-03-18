----------------------------------------------------------------------------------
-- Company: Sorbonne Universite 
-- Engineer: Youba FERHOUNE & Giorge Mendieta
-- 
-- Create Date: 12.03.2024 12:16:19
-- Design Name: 
-- Module Name: REGISTRE_DCC - Behavioral
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

entity REGISTRE_DCC is
  Port ( 
        clk: in std_logic;
        reset: in std_logic;
        load: in std_logic;
        shift: in std_logic;
        bit_out: out std_logic;
        Trame:  in std_logic_vector(50 downto 0)
  );
end REGISTRE_DCC;

architecture Behavioral of REGISTRE_DCC is
    signal shift_register : std_logic_vector(50 downto 0);

begin
        
    process (clk, reset)
    begin
        -- Reset Asynchrone
        if reset = '1' then 
            bit_out <= '0';
            shift_register <= (others => '0');
            
        elsif rising_edge(clk) then
            if load = '1' then
                shift_register <= Trame;
                bit_out <= shift_register(50);
                
            elsif shift = '1' then
                bit_out <= shift_register(50);
                shift_register <= shift_register(49 downto 0) & '0';
            end if;
             
        end if;
    end process;

end Behavioral;
