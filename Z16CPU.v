module Z16CPU(
  input wire i_clk,
  input wire i_rst
);

  reg [15:0] r_pc; // プログラムカウンタ

  wire [15:0] w_instr; // フェッチした命令
  wire [3:0] w_rd_addr; // RDのアドレス
  wire [3:0] w_rs1_addr; // RS1のアドレス
  wire [3:0] w_rs2_addr;
  wire [15:0] w_imm; // 即値
  wire w_rd_wen; // レジスタ書き込み有効化信号
  wire w_mem_wen; // メモリ書き込み有効化信号
  wire [3:0] w_alu_ctrl; // ALU演算制御信号線

  wire [15:0] w_rs1_data; // RS1のデータ
  wire [15:0] w_rs2_data;

  wire [15:0] w_alu_data; // ALUの演算結果
  wire [15:0] w_mem_rdata; // メモリからの読み出しデータ

  always @(posedge i_clk) begin
    if(i_rst) begin
      r_pc <= 16'h0000;
    end else begin
      r_pc <= r_pc + 16'h0002;
    end
  end

  Z16InstrMemory InstrMem(
    .i_addr(r_pc),
    .o_instr(w_instr)
  );

  Z16Decoder Decoder(
    .i_instr(w_instr),
    .o_rd_addr(w_rd_addr),
    .o_rs1_addr(w_rs1_addr),
    .o_rs2_addr(w_rs2_addr),
    .o_imm(w_imm),
    .o_rd_wen(w_rd_wen),
    .o_mem_wen(w_mem_wen),
    .o_alu_ctrl(w_alu_ctrl)
  );

  Z16RegisterFile RegFile(
    .i_clk(i_clk),
    .i_rs1_addr(w_rs1_addr),
    .o_rs1_data(w_rs1_data),
    .i_rs2_addr(w_rs2_addr),
    .o_rs2_data(w_rs2_data),
    .i_rd_addr(w_rd_addr),
    .i_rd_data(w_mem_rdata),
    .i_rd_wen(w_rd_wen)
  );

  Z16ALU ALU(
    .i_data_a(w_rs1_data),
    .i_data_b(w_imm),
    .i_ctrl(w_alu_ctrl),
    .o_data(w_alu_data)
  );

  Z16DataMemory DataMem(
    .i_clk(i_clk),
    .i_addr(w_alu_data),
    .i_wen(w_mem_wen),
    .i_data(w_rs2_data),
    .o_data(w_mem_rdata)
  );
endmodule
