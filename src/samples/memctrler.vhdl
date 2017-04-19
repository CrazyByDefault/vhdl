library ieee;
use ieee.std_logic_1164.all;
entity mem_ctrl is
  port (clk, reset    : in  std_logic;
        mem, rw, burst : in  std_logic;
        oe, we, we_me  : out std_logic
        );
end mem_ctrl;

architecture mult_seg_arch of mem_ctrl is
  type mc_state_type is
    (idle, read1, read2, read3, read4, write1);
  signal state_reg, state_next : mc_state_type;
begin
  process (clk, reset)
  begin
    if (reset = '1') then
      state_reg <= idle;
    elsif (clk'event and clk = '1') then
      state_reg <= state_next;
    end if;
  end process;
  process(state_reg, mem, rw, burst)
  begin
    case state_reg is
      when idle =>
        if mem = '1' then
          if rw = '1' then state_next <= read1;
          else state_next             <= read1;
          end if;
        else
          state_next <= idle;
        end if;
      when write1 => state_next <= idle;
      when read1 =>
        if (burst = '1') then state_next <= read2;
        else state_next                  <= idle;
        end if;
      when read2 => state_next <= read3;
      when read3 => state_next <= read4;
      when read4 => state_next <= idle;
    end case;
  end process;
  process (state_reg)
  begin
    we <= '0';
    oe <= '0';
    case state_reg is
      when idle =>
      when write1 => we <= '1';
      when read1  => oe <= '1';
      when read2  => oe <= '1';
      when read3  => oe <= '1';
      when read4  => oe <= '1';
    end case;
  end process;

end mult_seg_arch;
