
from enum import Enum

from collections import deque


def state_to_string(state):
    if len(state) == 0:
        return "4'b0000"
    elif len(state) == 1:
        return f"{{2'b00,`{state[0]}}}"
    else:
        return f"{{`{state[0]},`{state[1]}}}"

class RequestState(Enum):
    ABSENT = 0
    REQUESTED = 1
    QUEUED = 2
    RETIRED = 3    
    def __str__(self):
        return self.name   # only the name, no class or value
    def __repr__(self):
        return self.name   # used by REPL, logs, containers

    
class NextPC(Enum):
    PC = 1
    PC_PLUS_4 = 2
    BTA = 3
    def __str__(self):
        return self.name   # only the name, no class or value
    def __repr__(self):
        return self.name   # used by REPL, logs, containers
            
class NextRequest(Enum):
    NONE=0,
    NEXT_PC=2,
    NEXT_PC_PLUS_4=3
    def __str__(self):
        return self.name   # only the name, no class or value
    def __repr__(self):
        return self.name   # used by REPL, logs, containers    

def transition(state, c_ack, c_stall, id_stall, ex_take_branch):
    print(f"{state}({state_to_string(state)}),c_ack={c_ack},c_stall={c_stall},id_stall={id_stall},ex_take_branch={ex_take_branch}:")
    transitions_vector.write(f"{{state,c_ack,c_stall,id_stall,ex_take_branch}}={{{state_to_string(state)},1'b{c_ack},1'b{c_stall},1'b{id_stall},1'b{ex_take_branch}}};\n#1;\n")
    state = state[:]
    answered = False
    if len(state) != 0 and c_ack:
        if state[0] == RequestState.RETIRED:
            state = state[1:]
        elif state[0] in [RequestState.QUEUED, RequestState.REQUESTED]:
            answered = True
            state = state[1:]
    if len(state) != 0 and not c_stall:
        if state[-1] == RequestState.REQUESTED:
            state[-1] = RequestState.QUEUED        
    if len(state) != 0 and state[-1] == RequestState.REQUESTED:
        state = state[:-1]
    print(f"    --> {'ANSWERED,' if answered else ''}{state}")
    
    if_instr_valid = 0
    if ex_take_branch:
        # current answer is dropped. All queued requests are retired
        state = [RequestState.RETIRED for _ in state]
        next_pc = NextPC.BTA
    elif id_stall:
        # no branch but a stall 
        if answered:
            # The answered request must be dropped, ID is not ready to get it
            if len(state) != 0 and state[0] == RequestState.QUEUED:
                # that's a problem: PC+4 is already queued: mark it as retired
                state[0] = RequestState.RETIRED
            next_pc = NextPC.PC
        else:
            # There was no current answer. Fine. Everything queued is still valid
            next_pc = NextPC.PC
    else:
        # No ID stall, no branch
        if_instr_valid = 1 if answered else 0
        if answered:
            next_pc = NextPC.PC_PLUS_4
        else:
            next_pc = NextPC.PC

    print(f"    --> {state},if_instr_valid={if_instr_valid}")

    next_request = NextRequest.NONE
    if len(state) < 2:
        # emit a new request, but only if total number of requests is less than 2
        state.append(RequestState.REQUESTED)
        if ex_take_branch:
            next_request = NextRequest.NEXT_PC
        elif state[0] != RequestState.QUEUED:
            next_request = NextRequest.NEXT_PC
        else:
            next_request = NextRequest.NEXT_PC_PLUS_4
        
    print(f"    --> {state}({state_to_string(state)}),next_pc={next_pc},next_request={next_request}")
    
    transitions_vector.write(f"if({{next_state,if_instr_valid,next_pc,next_request}}!={{{state_to_string(state)},1'b{if_instr_valid},`NEXT_PC_{next_pc}, `NEXT_REQUEST_{next_request}}})")
    transitions_vector.write(f"$display(\"ERROR on (state=%b,c_ack=%b,c_stall=%b,id_stall=%b,ex_take_branch=%b).\\n    Got      (next_state=%b,if_instr_valid=%b,next_pc=%b,next_request=%b)\\n    Expected (next_state=%b,if_instr_valid=%b,next_pc=%b,next_request=%b)\",state, c_ack, c_stall,id_stall,ex_take_branch,next_state,if_instr_valid,next_pc,next_request,{state_to_string(state)},1'b{if_instr_valid},`NEXT_PC_{next_pc}, `NEXT_REQUEST_{next_request});")
   
    return state
    
    

    
def generate():
    all_states = []
    work_queue = deque()
    
    work_queue.append([])
    all_states.append([])
    while len(work_queue) != 0:
        state = work_queue.popleft()
        for ex_take_branch in [0,1]:
            for id_stall in [0,1]:
                for c_ack in [1,0]:
                    for c_stall in [1,0]:
                        next_state = transition(state, c_ack, c_stall, id_stall, ex_take_branch)
                        if not next_state in all_states:
                            all_states.append(next_state)
                            work_queue.append(next_state)

transitions_vector = open("IF_transitions_vector.sv", "w")           
            
generate()

transitions_vector.close()
