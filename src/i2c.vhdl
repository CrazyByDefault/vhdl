library ieee;
library std;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use ieee.std_logic_textio.all;
use std.textio.all;


entity i2c is
  generic (
    SLAVE_ADDR : std_logic_vector(6 downto 0)
    );

  port (
    
    sda : in std_logic;
    scl : in std_logic;
    ack_one : in std_logic;
    ack_two : in std_logic;

    --Data to the Master from the outside world
    --data_to_master : in std_logic_vector(7 downto 0);
    data_recieved_at_slave : out std_logic_vector(7 downto 0)

    );
  end entity i2c;

  architecture arch of i2c is

    type state_t is (idle, start_addr_tx, write, read, slave_hit_addr, slave_hit_data, done);
    
    signal state_reg : state_t := idle;
    
  
    --Master
    signal data_to_send : std_logic_vector(7 downto 0) := (others => '0');
    signal addr_to_send_to : std_logic_vector(6 downto 0) := ('0', '1', '0', '1', '0', '0', '1');
    signal rw_bit : std_logic := '0';
    signal ack_from_slave : std_logic := '1';

    signal ack_tolerance : integer := 0;

    --Medium
    --signal sda : std_logic := '1';
    --signal scl : std_logic := '1';

    --Slave
    signal addr_reg : std_logic_vector(6 downto 0) := (others => '0');
    signal data_storage : std_logic_vector(7 downto 0) := (others => '0');
    shared variable bit_cnt : integer range 0 to 8;
  
  begin
    
    process (scl) is
    begin
      if rising_edge(scl) then
        --assert false report ("ENTITY:  starts");

        case state_reg is

          when idle =>
            if sda = '1' then
              assert false report ("ENTITY:  is happening in idle");
              state_reg <= start_addr_tx;
              assert false report ("ENTITY:  is moving to addr_tx");
              bit_cnt := 0;
            end if;


          when start_addr_tx =>
            if bit_cnt < 7 and rising_edge(scl) then
              assert false report ("ENTITY:  recieved " & integer'image(bit_cnt) & "th bit of address");
              addr_reg(6 - bit_cnt) <= sda;
              bit_cnt := bit_cnt + 1;
              assert false report ("ENTITY: bit_cnt < 7");
              assert false report (integer'image(bit_cnt));           
            elsif bit_cnt = 7 and rising_edge(scl) then
              bit_cnt := bit_cnt + 1;
              
              rw_bit <= sda;
              assert false report ("ENTITY: recieved rw bit after address");
            end if;

            if bit_cnt = 8 and rising_edge(scl) then
              assert false report ("ENTITY: going to ack_one_state");
              bit_cnt := 0;
              state_reg <= slave_hit_addr;
            end if;
          



          when slave_hit_addr =>
            assert false report ("ENTITY:  is happening in slave ack one state");
            --if addr_reg = addr_to_send_to then
             ack_from_slave <= ack_one;
            --end if;
            if rising_edge(scl) and ack_from_slave = '0' and ack_tolerance < 4 then
              assert false report ("ENTITY: Got ack! Moving to read/write state");
              if rw_bit = '0' then
                state_reg <= write;
              else
                state_reg <= read;
              end if;
            elsif ack_tolerance = 4 then 
              assert false
                report ("no ack in 4 cycles, switching to idle")
                severity note;
              state_reg <= idle;
            else
              ack_tolerance <= ack_tolerance + 1;
              assert false report ("ENTITY: Haven't gotten an ack for " & integer'image(ack_tolerance) & " cycles, waiting.");
            end if;



          when slave_hit_data =>
            assert false report ("ENTITY:  is happening in slave ack two state");
            ack_from_slave <= ack_two;
            if ack_from_slave = '0' then 
            	state_reg <= done;
            else 
            	assert false
            	  report ("ENTITY: no ack after data, switching to idle")
            	  severity note;
            	state_reg <= idle;
            end if;


          when done =>
            assert false report ("ENTITY:  is happing in done");
            null;
            

          when write =>
            assert false report ("ENTITY:  is happening in write state");
            if rising_edge(scl) then
              if bit_cnt < 8 then
                assert false report ("ENTITY: recieved and stored " & integer'image(bit_cnt) & "th bit of data");
                data_recieved_at_slave(7 - bit_cnt) <= sda;
              end if;
              bit_cnt := bit_cnt + 1;
            end if;

            if falling_edge(scl) and bit_cnt = 8 then
              state_reg <= slave_hit_data;
              bit_cnt := 0;
            end if;

          when read =>
            assert false report ("ENTITY:  is happening in read state");
            assert false
              report ("WHY ARE YOU READING? WHYYY?")
              severity note;
            state_reg <= idle;



        end case;

        --if sda = '1' and bit_cnt = 8 then
        --  state_reg   <= start_addr_tx;
        --  bit_cnt     := 0;
        --end if;

      end if;
    end process;                    
  
  end architecture arch; -- arch