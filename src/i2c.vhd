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
    signal bit_cnt : integer range 0 to 8 := '0';
  
    --Master
    signal data_to_send : std_logic_vector(7 downto 0) := (others => '0');
    signal addr_to_send_to : std_logic_vector(6 downto 0) := ('0', '1', '0', '1', '0', '0', '1');
    signal rw_bit : std_logic := '0';
    signal ack_from_slave : std_logic := '1';

    --Medium
    signal sda : std_logic := '1';
    signal scl : std_logic := '1';

    --Slave
    signal addr_reg : std_logic_vector(6 downto 0) := (others => '0');
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


          when start_addr_tx =>
            if rising_edge(clk) then
              if bit_cnt < 7 then
                bit_cnt <= bit_cnt + 1;
                addr_reg(6 - bit_cnt) <= sda;
              elsif bit_cnt = 7 then
                bit_cnt <= bit_cnt + 1;
                rw_bit <= sda;
                end if;
              end if;

              if bit_cnt = 8 and falling_edge(clk) then
                bit_cnt <= 0;
                state_reg = slave_hit_addr;
              end if;


          when slave_hit_addr =>
            if addr_reg = addr_to_send_to;
              ack_from_slave <= '0';
            end if;

            if falling_edge(clk) and ack_from_slave = '0' then
              if rw_bit = '0' then
                state_reg <= write;
              else
                state_reg <= read;
              end if;
            end if;

          when slave_hit_data =>
            



          when write =>
            if rising_edge(clk) then
              bit_cnt <= bit_cnt + 1;
              if bit_cnt < 8 then
                data_storage(7 - bit_cnt) <= sda;
              end if;
            end if;

            if falling_edge(clk) and bit_cnt = 8 then
              state_reg <= slave_hit_data;
              bit_cnt <= 0;
            end if;

          when read =>
            assert false
              report ("WHY ARE YOU READING? WHYYY?");
              severity note;
            state_reg <= idle;





                    
  
  end architecture ; -- arch