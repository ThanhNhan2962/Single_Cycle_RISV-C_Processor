library verilog;
use verilog.vl_types.all;
entity alu_and is
    port(
        i_and_a         : in     vl_logic_vector(31 downto 0);
        i_and_b         : in     vl_logic_vector(31 downto 0);
        o_and_result    : out    vl_logic_vector(31 downto 0)
    );
end alu_and;
