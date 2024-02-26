library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity my_led is
    Port (
        sw_state : in  STD_LOGIC_VECTOR (3 downto 0); -- Entr�e sur 4 bits
        leds     : out STD_LOGIC_VECTOR (15 downto 0) -- Sortie sur 16 bits
    );
end my_led;

architecture Behavioral of my_led is
begin
    process(sw_state)
    begin
        -- Allumer les LEDs correspondant aux bits � 1 dans sw_state
        leds <= (others => '0');
        for i in 0 to 3 loop
            if sw_state(i) = '1' then
                leds(i*4+3 downto i*4) <= (others => '1');
            end if;
        end loop;
    end process;
end Behavioral;


