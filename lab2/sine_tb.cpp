#include "verilated.h"
#include "verilated_vcd_c.h"
#include "Vsinegen.h"

int main(int argc, char **argv, char **env) {
  Verilated::commandArgs(argc, argv);
  Vsinegen* top = new Vsinegen;
  Verilated::traceEverOn(true);
  VerilatedVcdC* tfp = new VerilatedVcdC;
  top->trace(tfp, 99);
  tfp->open("sinegen.vcd");
  top->clk = 1;
  top->rst = 0;
  top->en = 1;
  for (int simcyc=0; simcyc<1000000; simcyc++) {
    for (int tick=0; tick<2; tick++) {
      tfp->dump (2*simcyc+tick);
      top->clk = !top->clk;
      top->eval ();
    }
    if (Verilated::gotFinish()) exit(0);
    }
  tfp->close(); 
  exit(0);
}