library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity my_led is
    Port (
        sw_state : in  STD_LOGIC_VECTOR (3 downto 0); -- Entrée sur 4 bits
        leds     : out STD_LOGIC_VECTOR (15 downto 0) -- Sortie sur 16 bits
    );
end my_led;

architecture Behavioral of my_led is
begin
    process(sw_state)
    begin
        -- Allumer les LEDs correspondant aux bits à 1 dans sw_state
        leds <= (others => '0');
        for i in 0 to 3 loop
            if sw_state(i) = '1' then
                leds(i*4+3 downto i*4) <= (others => '1');
            end if;
        end loop;
    end process;
end Behavioral;


leds: out std_logic_vector(15 downto 0);
leds: out std_logic_vector(15 downto 0);
leds => leds,
leds: out std_logic_vector(15 downto 0);
signal sw_state: std_logic_vector(3 downto 0);
L0: entity work.led port map (sw_state,leds);
	sw_state(0) <= slv_reg0(0);
    sw_state(1) <= slv_reg0(1);
    sw_state(2) <= slv_reg1(0);
    sw_state(3) <= slv_reg1(1);
