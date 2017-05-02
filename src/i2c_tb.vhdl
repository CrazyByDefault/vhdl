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
	signal ack_one, ack_two : std_logic := '0';
	signal data_to_master : std_logic_vector(0 to 7) := "01001110";
	signal data_recieved_at_slave : std_logic_vector(7 downto 0);
	signal clk : std_logic := '1';

	signal tb_bit_cnt : integer :=  0;
	constant slave_addr : std_logic_vector(0 to 6) := "0101001";
	signal blah_cnt : integer := 0;

	type state_t is (idle, addr_tx, ack_one_state, ack_two_state);
	signal state_reg : state_t := idle;

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
		if done_tx = false then	
			clk <= '0';
			scl <= clk;
			wait for T/2;
			clk <= '1';
			scl <= clk;
			wait for T/2;
		else
			wait;
		end if;		
	end process;
----ignore------------
---------------------------------------------------------------------------
	--process 
	--begin 
	--	if done_tx = false then
	--		scl <= not scl after T/2;
	--	else
	--		wait;
	--	end if;
	--end process;
		--procedure wait_for(signal clk: std_logic; bool : boolean) is 
		--begin 
		--	for bool = true loop
		--		wait until rising_edge(clk);
		--	end loop;
		--end procedure;
-------------------------------------------------------------------------------------
	-- assigning data and address to sda and and sending it to slave register. 
	process (clk)
	begin		
		if done_tx = false and blah_cnt > 1 then
			if state_reg = addr_tx then

				if tb_bit_cnt = 0 and rising_edge(clk) then
					sda <= '1';
					tb_bit_cnt <= tb_bit_cnt + 1;
					blah_cnt <= blah_cnt + 1;			
					assert false report ("TB: Sent init 1");
				end if;

				if tb_bit_cnt < 8 and tb_bit_cnt > 0  and rising_edge(clk) then 
					assert false report ("TB: Sending " & integer'image(tb_bit_cnt - 1) & "th address");
					sda <= slave_addr(tb_bit_cnt - 1);
					tb_bit_cnt <= tb_bit_cnt + 1;
					blah_cnt <= blah_cnt + 1; 
					--wait for 1 us;
				end if;
				
				if tb_bit_cnt = 8 and rising_edge(clk) then 
					assert false report ("TB: Sending rw bit");
					sda <= rw_bit;
					--assert false report ("TB: 1");
					tb_bit_cnt <= tb_bit_cnt + 1;
					--assert false report ("TB: 2");
					blah_cnt <= blah_cnt + 1;
					--assert false report ("TB: 3");
					state_reg <= ack_one_state;
					--assert false report ("TB: Leaving addr_tx");
					--wait for 1 us;
				end if;

			end if;


			if state_reg = ack_one_state then
				assert false report ("TB: in ack one and write state");
				if tb_bit_cnt = 9 and rising_edge(clk) then 
					--assert false report ("TB: ack_one");
					ack_one <= '0';
					tb_bit_cnt <= 0;

				end if;

				assert (ack_one = '0') report ("address not recieved") severity note;

				--wait for 1 us;
				
				if ack_one = '0' and tb_bit_cnt < 8 then
					if rising_edge(clk) then
						assert false report ("TB: sending " & integer'image(tb_bit_cnt) & "th bit of Data");
						sda <= data_to_master(tb_bit_cnt);
						tb_bit_cnt <= tb_bit_cnt + 1;
						blah_cnt <= blah_cnt + 1;
						--wait for 1 us;
						--data_recieved_at_slave(i) <= sda;
					end if;

					if tb_bit_cnt = 8 then
						state_reg <= ack_two_state;						
					end if ;
				end if;

			end if;

			if state_reg = ack_two_state then

				if (tb_bit_cnt = 8) and rising_edge(clk) then
					ack_two <= '0';
					--wait for 1 us;
				end if;
				
			end if ;

			assert (ack_two = '0') report ("data not recieved") severity note;
			--assert (data_recieved_at_slave = data_to_master) report ("data not transmitted properly") severity note;
			if blah_cnt = 50 then
				done_tx <= true;
			end if;
		else
			blah_cnt <= blah_cnt + 1;
			state_reg <= addr_tx;
		end if;
		assert false report(integer'image(tb_bit_cnt) & " " & integer'image(blah_cnt));
	end process;

end arch;

 