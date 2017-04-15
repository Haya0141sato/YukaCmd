#include <stdlib.h>
#include <string>

int main(void)
{
	std::string cmd = "./yukaCmd.sh ";
	std::string txt = cmd+"\"C＋＋のゆかりさんです\"";
	system(txt.c_str());
}
