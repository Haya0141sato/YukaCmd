package example.src;

public class rabbit
{
public static void main(String[] args)
	{
try
		{
String readStr="javaのゆかりさんです";
Runtime r = Runtime.getRuntime();
r.exec("./yukaCmd.sh "+readStr);
		}
catch(Exception e)
		{;}
	}
}
