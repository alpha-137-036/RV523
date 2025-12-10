module IF_transitions_tb();

    logic[3:0] state;
    logic      c_ack;
    logic      c_stall;
    logic      id_stall;
    logic      ex_take_branch;
    wire[3:0] next_state;
    wire      if_instr_valid;
    wire[1:0] next_pc;
    wire[1:0] next_request;
    
    IF_transitions u_transitions(
        .state(state),
        .c_ack(c_ack),
        .c_stall(c_stall),
        .id_stall(id_stall),
        .ex_take_branch(ex_take_branch),
        .next_state(next_state),
        .if_instr_valid(if_instr_valid),
        .next_pc(next_pc),
        .next_request(next_request)
    );
    
    initial begin
        `include "IF_transitions_vector.sv"
    end
endmodule