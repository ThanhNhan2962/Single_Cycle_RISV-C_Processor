library verilog;
use verilog.vl_types.all;
entity alu_srl is
    port(
        i_srl_data      : in     vl_logic_vector(31 downto 0);
        i_srl_shift     : in     vl_logic_vector(4 downto 0);
        o_srl_result    : out    vl_logic_vector(31 downto 0)
    );
end alu_srl;
