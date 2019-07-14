// ex. 0x------00 => 0x3030----

int hextoascii()
{
	register int hex asm("r1");

	return (((hex / 10) + 48) << 24) + (((hex % 10) + 48) << 16);
}
