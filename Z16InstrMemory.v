module Z16InstrMemory(
  input wire [15:0] i_addr,
  output wire [15:0] o_instr
);

  // 命令メモリの実体 アドレス16bit/命令長5bit
  wire [15:0] mem[4:0];
  assign o_instr = mem[i_addr[15:1]]; // 上位15bitだけを使う→2byteにアライメントして取り出し

  assign mem[0] = 16'h406A; // LOAD 4 ZR G2
  assign mem[1] = 16'h0000;
  assign mem[2] = 16'h0000;
  assign mem[3] = 16'h008A; // LOAD 0 ZR G4
  assign mem[4] = 16'h0000;
endmodule
