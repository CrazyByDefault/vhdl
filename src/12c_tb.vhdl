library ieee;
use ieee.std_logic_1164.all;

entity i2c_tb is
end i2c_tb;

architecture arch of i2c_tb is
	
	-- Component declaration
	component i2c is
		port(

			clk : in std_logic := '1';
			ack_one : in std_logic;   -- adress
			ack_two : in std_logic;   -- data
			--rw_bit : in std_logic := '1';	
			data_to_master : in std_logic_vector(7 downto 0) ;
			data_recieved_at_slave : out std_logic_vector(7 downto 0)

			);
	end component; 


	constant T : time := 1000 ns;
	shared variable done_tx : boolean := false;

	signal clk, ack_one, ack_two : std_logic;
	signal data_to_master, data_recieved_at_slave : std_logic_vector(7 downto 0);

	begin -- begin Architecture
		mapping : i2c port map(clk => clk, ack_one => ack_one, ack_two => ack_two,

		data_to_master => data_to_master, data_recieved_at_slave => data_recieved_at_slave);

		process 
			if done_tx = false then		
				clk <= '0';
				wait for T/2;
				clk <= '1';
				wait for T/2;
			else
				wait;
			end if;
		end process;

		procedure write_to(port ) is
			if rising_edge(clk) then 

			end if;
		end procedure;

		-- write a bit
		procedure write_bit (
      		constant a_bit : in std_logic) is
    		begin
    			
    	end procedure write_bit;

    	--Write a byte of data
		procedure write_byte(
    		constant a_byte : in std_logic_vector(7 downto 0)) is
    		begin
    			for i in 7 downto 0 loop
        			write_bit(a_byte(i));
      			end loop;
    	end procedure write_byte;


		process 
			type pattern_type is record 
				data_to_master, data_recieved_at_slave : std_logic_vector;
				clk, ack_two, ack_one : std_logic;
			end record;

			type pattern_array is array (natural range <>) of pattern_type;
			constant patterns : pattern_array := 			
		

			begin

				for i in patterns'range loop


				end loop;	

		end process;





end arch;

 