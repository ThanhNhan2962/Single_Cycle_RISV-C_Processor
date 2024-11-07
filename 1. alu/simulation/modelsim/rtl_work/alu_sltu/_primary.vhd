library verilog;
use verilog.vl_types.all;
entity alu_sltu is
    port(
        i_sltu_a        : in     vl_logic_vector(31 downto 0);
        i_sltu_b        : in     vl_logic_vector(31 downto 0);
        o_sltu_result   : out    vl_logic
    );
end alu_sltu;
