module Z16DataMemory(
  input wire i_clk,
  input wire [15:0] i_addr,
  input wire i_wen,
  input wire [15:0] i_data,
  output wire [15:0] o_data
);

  // メモリの実体
  reg [15:0] mem[1023:0];

  // Load
  // Chappyによる概要
  // i_addr[10:1] は、i_addr の 11 ビット目から 1 ビット目までを取り出し、メモリアレイのインデックスとして使うためのスライスです。
  // これにより下位ビット i_addr[0] は無視され、常に 0 扱いになるので、アドレスは 2 バイト（または 4 バイトなどの "word"）境界に整列します。したがって偶数アドレスだけが実際のメモリアクセス対象になります。
  // 抽出された 10 ビット分（[10:1]）で 2^10=1024ワードアクセスできる
  // 要するに、i_addr の最下位ビットをバイトオフセットとして使いながら、残りのビットで実際のワードアドレスを指定する設計意図です。
  assign o_data = mem[i_addr[10:1]];

  // Store
  always @(posedge i_clk) begin
    if (i_wen) begin
      mem[i_addr[10:1]] <= i_data;
    end
  end
endmodule
