library ieee;
use ieee.std_logic_1164.all;

entity i2c_tb is
end i2c_tb;

architecture arch of i2c_tb is
	
	-- Component declaration
	component i2c is
		--generic (slave_addr := std_logic_vector(6 downto 0));
		port(
			sda : in std_logic := '1';
			scl : in std_logic := '0';
			ack_one : in std_logic;   -- adress
			ack_two : in std_logic;   -- data
			--data_to_master : in std_logic_vector(7 downto 0) ;
			data_recieved_at_slave : out std_logic_vector(7 downto 0)

			);
	end component; 

	constant T : time := 1000 ns;
	signal done_tx : boolean := false;
	signal rw_bit : std_logic := '0';
	signal sda, scl : std_logic := '1'; 
	signal ack_one, ack_two : std_logic;
	signal data_to_master : std_logic_vector(7 downto 0) := "10101010";
	signal data_recieved_at_slave : std_logic_vector(7 downto 0);
	signal clk : std_logic := '0';
	--signal master_puppy : std_logic_vector(7 downto 0) := "10101010";
	--signal pet_puppy : std_logic_vector(7 downto 0) := "10101010";
	signal bit_cnt : integer range 0 to 9 := 0;
	constant slave_addr : std_logic_vector(6 downto 0) := "0101001";
begin -- begin Architecture

		testbench : entity work.i2c 
		-- mapping
		generic map(slave_addr => "0101001")
		port map(
			sda => sda, scl => scl,
			ack_one => ack_one, 
			ack_two => ack_two, 
			--data_to_master => data_to_master, 
			data_recieved_at_slave => data_recieved_at_slave);

		--clock
	process 
	begin
		--for i in 0 to 18 loop
		if done_tx = false then	
			clk <= '0';
			wait for T/2;
			clk <= '1';
			wait for T/2;
		else
			wait;
		end if;	
		--end loop ; -- identifier
	end process;

	-- assigning data and address to sda and and sending it to slave register. 
	process (clk) is
	begin
		--wait for 1 us;
		--for i in 6 downto 0 loop 
		scl <= clk;

		if bit_cnt = 0 then
			assert false report ("TB - sent 1");
			sda <= '1';
			bit_cnt <= bit_cnt + 1;
		end if;
		if bit_cnt = 1 then
			assert false report ("TB - sending sda"); 
			sda <= slave_addr(6 - bit_cnt);
			bit_cnt <= bit_cnt + 1; 
			--wait for 1 us;
		end if;
		--end loop;
		if bit_cnt = 8 and rising_edge(clk) then 
			assert false report ("TB - sending rw bit");
			sda <= rw_bit;
			bit_cnt <= bit_cnt + 1;
			--wait for 1 us;
		end if;


		if bit_cnt = 9 and rising_edge(scl) then 
			assert false report ("TB - sending ack_one");
			ack_one <= '0';
			bit_cnt <= 0;
		end if;

    	assert (ack_one = '0') report ("address not recieved") severity error;

    	
    	if ack_one = '0' and rising_edge(scl) then
			--for i in 7 downto 0 loop
			if rising_edge(scl) then
				sda <= data_to_master(7 - bit_cnt);
				--wait for 1 us;
				--bit_cnt <= bit_cnt + 1;
				--data_recieved_at_slave(i) <= sda;
			end if;
			--end loop;
		end if;
		if (bit_cnt = 8) and rising_edge(scl) then
			ack_two <= '0';
		end if;

		assert (ack_two = '0') report ("data not recieved") severity error;
		assert (data_recieved_at_slave = data_to_master) report ("data not transmitted properly") severity failure;
		done_tx <= true;

	end process;

end arch;

 