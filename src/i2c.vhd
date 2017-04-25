library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity i2c is
  generic (
    SLAVE_ADDR : std_logic_vector(6 downto 0)
    );

  port (
    
    clk : in std_logic;
    ack_one : in std_logic;
    ack_two : in std_logic;

    --Data to the Master from the outside world
    data_to_master : in std_logic_vector(7 downto 0);
    data_recieved_at_slave : out std_logic_vector(7 downto 0)

    );
  end entity i2c;

  architecture arch of i2c is

    type state_t is (idle, start_addr_tx, write, read, slave_hit_addr, slave_hit_data, done);
    
    signal state_reg : state_t := idle;
    signal bit_cnt : std_logic := '0';
  
    --Master
    signal data_to_send : std_logic_vector(7 downto 0) := (others => '0');
    signal addr_to_send_to : std_logic_vector(6 downto 0) := ('0', '1', '0', '1', '0', '0', '1');
    signal rw_bit : std_logic := '0';
    signal ack_from_slave : std_logic := '1';

    --Medium
    signal sda : std_logic := '1';
    signal scl : std_logic := '1';

    --Slave
    signal data_storage : std_logic_vector(7 downto 0) := (others => '0');
  
  begin
    
    process (clk) is
    begin
      if rising_edge(clk) then


        case state_reg is

          when idle =>
            if sda = '1' then
              state_reg <= start_addr_tx;
              bit_cnt <= '0';
            end if;
  
  end architecture ; -- arch