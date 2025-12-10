//
// State encoding:
// two requests: [3:2] oldest, [1:0] youngest
//
`define ABSENT    2'b00
`define REQUESTED 2'b01
`define QUEUED    2'b10
`define RETIRED   2'b11

// Next PC encoding:
`define NEXT_PC_PC 2'b00
`define NEXT_PC_PC_PLUS_4 2'b01
`define NEXT_PC_BTA 2'b10

// Next request encoding:
`define NEXT_REQUEST_NONE           2'b00
`define NEXT_REQUEST_NEXT_PC        2'b10
`define NEXT_REQUEST_NEXT_PC_PLUS_4 2'b11

module IF_transitions(
    input logic[3:0] state,
    
    input c_ack,
    input c_stall,
    input id_stall,
    input ex_take_branch,

    output logic[3:0] next_state,
    output logic      if_instr_valid,
    output logic[1:0] next_pc,
    output logic[1:0] next_request
);    
    always @(*) begin
        logic answered;
        if_instr_valid = 0;
        answered = 0;
        
        next_state = state;
        
        if (c_ack) begin
            if (next_state[3:2] == `RETIRED) begin
                // Oldest retired request has been ack'ed, we can now drop it
                next_state[3:2] = `ABSENT;
            end else if (next_state[3:2] == `QUEUED) begin
                answered = 1;
                next_state[3:2] = `ABSENT;
            end else if (next_state[1:0] == `REQUESTED) begin
                // request has been combinatorially ack'ed
                answered = 1;
                next_state[1:0] = `ABSENT;
            end
        end
        if (!c_stall) begin
            // c_stall = 0 means the current request is queued
            if (next_state[1:0] == `REQUESTED) begin
                next_state[1:0] = `QUEUED;
            end
        end
        if (next_state[1:0] == `REQUESTED) begin
            // The request was not queued
            next_state = next_state >> 2;
        end
                
        // What to do next?
        if (ex_take_branch) begin
            // Current result must be dropped...
            // All queued requests become retired
            if (next_state[3:2] == `QUEUED) begin
                next_state[3:2] = `RETIRED;
            end
            if (next_state[1:0] == `QUEUED) begin
                next_state[1:0] = `RETIRED;
            end
            if_instr_valid = 0;
            next_pc = `NEXT_PC_BTA;
            next_request = `NEXT_REQUEST_NEXT_PC;
        end else if (id_stall) begin
            if (answered) begin
                // This valid instruction must be dropped, unfortunately...
                if (next_state[1:0] == `QUEUED) begin
                    // This queued request is out of sync and must be retired
                    // It will be reissued in two cycles
                    next_state[1:0] = `RETIRED;
                end
            end
            next_pc = `NEXT_PC_PC;
            next_request = `NEXT_REQUEST_NEXT_PC;
        end else begin
            if_instr_valid = answered;
            next_pc = answered ? `NEXT_PC_PC_PLUS_4 : `NEXT_PC_PC;
            next_request = `NEXT_REQUEST_NEXT_PC;
        end
        
        // Try to issue one more request.
        if (next_state[3:2] == `ABSENT) begin
            next_state = (next_state << 2) | `REQUESTED;
            if (next_state[3:2] == `QUEUED) begin
                next_request = `NEXT_REQUEST_NEXT_PC_PLUS_4;
            end
        end else begin
            next_request = `NEXT_REQUEST_NONE;
        end
    end
endmodule
