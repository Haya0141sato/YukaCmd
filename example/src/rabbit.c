#include <stdlib.h>
#include <string.h>

int main(void)
{
const char *com="./yukaCmd.sh ";
const char *txt="\"I'm C yukarin\"";
int size=sizeof(txt)+sizeof(com)+10;
char *command=(char*)(malloc(size));

strcat(command,com);
strcat(command,txt);

system(command);
free(command);
}
