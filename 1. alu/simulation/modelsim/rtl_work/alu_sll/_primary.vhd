library verilog;
use verilog.vl_types.all;
entity alu_sll is
    port(
        i_sll_data      : in     vl_logic_vector(31 downto 0);
        i_sll_shift     : in     vl_logic_vector(4 downto 0);
        o_sll_result    : out    vl_logic_vector(31 downto 0)
    );
end alu_sll;
