library ieee;
use ieee.std_logic_1164.all;

entity i2c_tb is
end i2c_tb;

architecture arch of i2c_tb is
	constant T : time := 1 us;

	component i2c is
		port(

			clk : in std_logic := '1';
			ack_one : in std_logic;
			ack_two : in std_logic;


			data_to_master : in std_logic_vector(7 downto 0) ;
			data_recieved_at_slave : out std_logic_vector(7 downto 0)

			);
	end component; -- arch

	signal clk, ack_one, ack_two : std_logic;
	signal data_to_master, data_recieved_at_slave : std_logic_vector(7 downto 0);

	begin
		mapping : i2c port map(clk => clk, ack_one => ack_one, ack_two => ack_two,

		data_to_master => data_to_master, data_recieved_at_slave => data_recieved_at_slave);

		process 
			clk <= '0';
			wait for T/2;
			clk <= '1';
			wait for T/2;
		end process;

		process 
			type pattern_type is record 
				data_to_master, data_recieved_at_slave : std_logic_vector;
				clk, ack_two, ack_one : std_logic;
			end record;

			type pattern_array is array (natural range <>) of pattern_type;
			constant patterns : pattern_array :=
					
		end process;


--Fuck Shishirk VHDL is a shitty piece of shit I'm failing maxwell 


end arch;

 