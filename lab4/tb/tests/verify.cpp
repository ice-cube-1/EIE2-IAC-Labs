#include "testbench.h"
#include <cstdlib>

class CpuTestbench : public Testbench
{
protected:
    void initializeInputs() override
    {
        top->clk = 1;
        top->rst = 0;
        top->pc = 0;
    }
};

TEST_F(CpuTestbench, BaseProgramTest)
{
    system("./compile.sh asm/program.S");

    for (int i = 0; i < 10; i++)
    {
        std::cout << "Tick " << i << ": a0 = " << (int)top->a0 <<" " << (int)top->pc<<" "<<(int)top->instr<< std::endl;
        runSimulation(1);
        if (top->a0 == 254)
        {
            SUCCEED();
        }
    }
    FAIL() << "Counter did not reach 254";
}

// Note this is how we are going to test your CPU. Do not worry about this for
// now, as it requires a lot more instructions to function
/**
 *
TEST_F(CpuTestbench, Return5Test)
{
    system("./compile.sh c/return_5.c");
    runSimulation(100);
    EXPECT_EQ(top->a0, 5);
}
 */

int main(int argc, char **argv)
{
    Verilated::commandArgs(argc, argv);
    testing::InitGoogleTest(&argc, argv);
    auto res = RUN_ALL_TESTS();

    return res;
}