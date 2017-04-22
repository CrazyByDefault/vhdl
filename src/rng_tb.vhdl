entity rng_tb is
end rng_tb;

architecture test of rng_tb is

	component RNG 
	port(in_bit : in std_logic; rand_bit : out std_logic);
	end component;

	for rng_r : rng use entity work.rng;
	signal in_bit, rand_bit : std_logic;

begin 
	rng_r : rng port map (in_bit => in_bit, rand_bit => rand_bit);

	process 
		type pattern_type is record 
			in_bit, rand_bit : std_logic;
		end record;

		type pattern_type is array (natural range <>) 


end test; -- test