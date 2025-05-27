///////////////////////////////////////////////////////////////////////////////
// File:        design.sv
// Author:      Youssef Zaafan Atya
// Date:        2025-05-27
// Description: I2C Memory implementation
///////////////////////////////////////////////////////////////////////////////
`ifndef DESIGN_SV
    `define DESIGN_SV
module i2c_mem (
    input   clk,rst,wr,
    input   [6:0]   addr,
    input   [7:0]   din,
    output  [7:0]   datard,
    output  reg     done
);
//Internals
wire sda;
reg  scl;
reg [7:0]   addrt;
reg [7:0]   temprd;
reg         en;
reg         sdat;
integer     count = 0;
 reg update;

///////////////////////////////////////
typedef enum bit [3:0] {idle = 0, start = 1, send_addr = 2, get_ack1 = 3, send_data = 4, get_ack2= 5, read_data = 6, complete = 7, get_addr = 8, send_ack1 = 9, get_data = 10, send_ack2 = 11 } state_type;
state_type state, nstate;
//State Machine (MASTER I2C)
always @(posedge clk )
begin
    if (rst)
    begin
        addrt <= 0;
        temprd <= 0;
        en <= 0;
        sdat <= 0; 
        count <= 0;
    end
    else
    begin
        case (state)
        idle: begin
            en <= 1'b1;
            scl <= 1'b1;
            sdat<=1'b1;
            state<=start;
            count<=0;
            done <= 1'b0;
            temprd<=0;
        end
        start : begin
            sdat <= 1'b0;
            addrt <= {addr,wr};
            state <= send_addr;
        end
        send_addr: begin
            if (count <= 7) begin
                sdat <= addrt[count];
                count <= count +1;
            end
            else begin
                state <= get_ack1;
                count <= 0;
                en <= 1'b0;
            end
        end
        get_ack1: begin
            if (sda == 1'b0) begin
                if ( wr ==1'b1) begin
                    state <= send_data;
                    en <= 1'b1;
                end
                else if (wr == 1'b0) begin
                    state <= read_data;
                    en <= 1'b0;
                end
            end
            else begin
                state <= get_ack1;
            end
        end
        send_data : begin
            if (count <= 7) begin
                sdat <= din[count];
                count <= count +1;
            end
            else begin
                state <= get_ack2;
                count <= 0;
                en <= 1'b0;
            end
        end
        get_ack2: begin
            if (sda == 1'b0) begin
                state <= complete;
            end
            else begin
                state <= get_ack2;
            end
        end
        read_data: begin
            if (count <= 9) begin
                temprd[7:0] <= {sda,temprd[7:1]}; //shifter
                count <= count +1;
            end
            else begin
                state <= complete;
                count <= 0;
            end
        end
        complete: begin
            if(update) begin
                state <= idle;
                done <= 1'b1;
            end
            else begin
                state <= complete;
            end
        end
        default: state <= idle;
        endcase
    end
end
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
////Slave I2C
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Internals
reg [7:0] mem [128];
integer countn = 0;
reg [7:0] addrn,data_rd,datan;
reg sdan;
always@(posedge clk) begin
    if (rst) begin
        for (int i=0; i<128; i++) begin
            mem[i]=0;
        end
        addrn<=0;
        datan<=0;
        update<=0;
    end
    else begin
        case (nstate)
            idle: begin
                addrn <=0;
                datan <=0;
                update <=0;
                data_rd<=0;
                if (scl && sdat)
                nstate <= start;
                else
                nstate <= idle;
            end 
            start: begin
                if (scl && !sdat) 
                nstate <= get_addr;
                else
                nstate <= start;
            end
            get_addr: begin
              if(countn<=7) begin
                addrn[countn]<=sdat;
                    countn <= countn+1;
                end
                else begin
                    nstate <= send_ack1;
                    countn <= 0;

                    //Prepare data for read
                    if(addrn[0]==1'b0)
                    data_rd <= mem[addrn[7:1]];
                end
            end
            send_ack1:begin
                sdan<=1'b0;
                //Checking the OP
                //write to slave
                if (addrn[0]==1'b1 && state == send_data) //state for master
                nstate <= get_data;
                //read from slave
                else if ( addrn[0]==1'b0 && state == read_data)
                nstate <= send_data;
                else
                nstate <= send_ack1;
            end
            get_data: begin
              if(countn<=7) begin
                datan[countn]<=sdat;
                    countn <= countn+1;
                    end
                else begin
                    nstate <= send_ack2;
                    countn <= 0;
                    //Prepare data for write
                    mem[addrn[7:1]] <= datan;
                end
            end
            send_ack2: begin
                sdan <= 1'b0;
                nstate <= complete;
            end
            send_data: begin
              if (countn <= 7) begin
                sdan <= data_rd[countn];
                    countn <= countn+1;
                end
                else begin
                    nstate <= complete;
                    countn <= 0;
                end
            end
            complete: begin
                update <=1'b1;
                nstate <= idle;
            end
            default: nstate <= idle;
        endcase
    end
end
////////////////////////////////////////////////////////////////////////

assign sda = (en == 1'b1) ? sdat : sdan;
assign datard = temprd;

endmodule
////////////////////////////////////////////////////////////////////////////////

interface i2c_i;
  logic clk, rst, wr;
  logic [6:0] addr;
  logic [7:0] din;
  logic  [7:0] datard;
  logic done;    
endinterface

`endif 